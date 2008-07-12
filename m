Return-Path: <linux-kernel-owner+w=401wt.eu-S1754497AbYGLUFD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754497AbYGLUFD (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Jul 2008 16:05:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752671AbYGLUEx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 Jul 2008 16:04:53 -0400
Received: from accolon.hansenpartnership.com ([76.243.235.52]:48626 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752645AbYGLUEw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Jul 2008 16:04:52 -0400
Subject: [PATCH] systemtap: add parser for simple markers
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: Theodore Tso <tytso@mit.edu>
Cc: "Frank Ch. Eigler" <fche@redhat.com>,
       linux-kernel <linux-kernel@vger.kernel.org>, systemtap@sourceware.org,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
In-Reply-To: <1215886965.3360.16.camel@localhost.localdomain>
References: <1215638551.3444.39.camel__22002.9595810503$1215638656$gmane$org@localhost.localdomain>
	 <y0m1w22qxoj.fsf@ton.toronto.redhat.com>
	 <1215697794.3353.5.camel@localhost.localdomain>
	 <20080710142208.GC1213@redhat.com>
	 <1215700996.3353.30.camel@localhost.localdomain>
	 <20080710153017.GB25939@mit.edu>
	 <1215886965.3360.16.camel@localhost.localdomain>
Content-Type: text/plain
Date: Sat, 12 Jul 2008 15:04:46 -0500
Message-Id: <1215893086.3360.25.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 (2.22.3.1-1.fc9) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the systemtap piece that allows you to use simple markers as
probe points for people who want to play around with the functionality.

James

---

>From a6b70f5c6faa0e9df4f9c84a5db5088b77ceaed9 Mon Sep 17 00:00:00 2001
From: James Bottomley <James.Bottomley@HansenPartnership.com>
Date: Fri, 11 Jul 2008 09:32:34 -0500
Subject: Add simple_marker statement

Now that the kernel drops simple markers in a __simple_marker section, update systemtap to parse for them by introducing an extra

<module>.simple_mark(<marker str>)

statement.  It would be nice to reuse the existing mark() directive,
but unfortunately, the parser can't cope with semantic dependent
parsing (it won't allow the registration of two identical patterns),
so the easiest way to get this to work is to introduce an additional
statement type.

Signed-off-by: James Bottomley <James.Bottomley@HansenPartnership.com>
---
 tapsets.cxx |  124 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++-
 1 files changed, 121 insertions(+), 3 deletions(-)

diff --git a/tapsets.cxx b/tapsets.cxx
index adfe10e..ce59102 100644
--- a/tapsets.cxx
+++ b/tapsets.cxx
@@ -458,6 +458,7 @@ static string TOK_MAXACTIVE("maxactive");
 static string TOK_STATEMENT("statement");
 static string TOK_ABSOLUTE("absolute");
 static string TOK_PROCESS("process");
+static string TOK_SIMPLE_MARK("simple_mark");
 
 // Can we handle this query with just symbol-table info?
 enum dbinfo_reqt
@@ -571,7 +572,15 @@ module_cache
 };
 typedef struct module_cache module_cache_t;
 
+struct marker_map_data {
+  string file;
+  int line;
+
+  marker_map_data(void) : line(-1) { };
+};
+
 #ifdef HAVE_TR1_UNORDERED_MAP
+typedef tr1::unordered_map<string,struct marker_map_data> marker_map_t;
 typedef tr1::unordered_map<string,Dwarf_Die> cu_function_cache_t;
 typedef tr1::unordered_map<string,cu_function_cache_t*> mod_cu_function_cache_t; // module:cu -> function -> die
 #else
@@ -579,6 +588,7 @@ struct stringhash {
   size_t operator() (const string& s) const { hash<const char*> h; return h(s.c_str()); }
 };
 
+typedef hash_map<string,struct marker_map_data,stringhash> marker_map_t;
 typedef hash_map<string,Dwarf_Die,stringhash> cu_function_cache_t;
 typedef hash_map<string,cu_function_cache_t*,stringhash> mod_cu_function_cache_t; // module:cu -> function -> die
 #endif
@@ -727,6 +737,8 @@ struct dwflpp
 
     function_name.clear();
     function = NULL;
+    delete marker_map;
+    marker_map = NULL;
   }
 
 
@@ -1583,6 +1595,82 @@ struct dwflpp
     dwarf_decl_line (function, linep);
   }
 
+  marker_map_t *marker_map;
+
+  void marker_map_populate(void)
+  {
+    assert(module);
+    marker_map = new marker_map_t;
+
+    Dwarf_Addr bias;
+    Elf_Scn* scn = 0;
+    size_t shstrndx;
+    // We prefer dwfl_module_getdwarf to dwfl_module_getelf here,
+    // because dwfl_module_getelf can force costly section relocations
+    // we don't really need, while either will do for this purpose.
+    Elf* elf = (dwarf_getelf (dwfl_module_getdwarf (module, &bias))
+		?: dwfl_module_getelf (module, &bias));
+
+    assert(elf);
+
+    // find the __simple_marker section
+    elf_getshstrndx (elf, &shstrndx);
+
+    while ((scn = elf_nextscn (elf, scn)) != NULL)
+      {
+	GElf_Shdr shdr_mem;
+	GElf_Shdr *shdr = gelf_getshdr (scn, &shdr_mem);
+	if (! shdr) continue; // XXX error?
+
+	const char *name = elf_strptr (elf, shstrndx, shdr->sh_name);
+	// looking for version 1 of the format
+	if (!strcmp(name, "__simple_marker.1"))
+	  break;
+      }
+    // no simple marker section
+    if (!scn)
+      return;
+
+    Elf_Data *rawdata = elf_rawdata(scn, NULL);
+    // section is empty
+    if (!rawdata)
+      return;
+    const char *data = (const char *)rawdata->d_buf;
+    for (unsigned int i = 0; i < rawdata->d_size; i++)
+      {
+
+	if (data[i] == '\0')
+	  continue;
+
+	const char *name = data + i;
+	i += strlen(name) + 1;
+	const char *file = data + i;
+	i += strlen(file) + 1;
+	const char *line = data + i;
+	i += strlen(line) + 1;
+	const char *format = data + i;
+	i += strlen(format) + 1;
+	const char *variables = data + i;
+	// no + 1 for last; i++ in for loop does that
+	i += strlen(variables);
+
+	(*marker_map)[name].file = file;
+	(*marker_map)[name].line = lex_cast<int>(line);
+      }
+  }
+
+  /**
+   * find marker - returns the line corresponding to the marker
+   * @marker - string corresponding to the marker
+   */
+  struct marker_map_data& find_marker (string marker)
+  {
+    if (!marker_map)
+      marker_map_populate();
+
+    return (*marker_map)[marker];
+  }
+
   bool die_has_pc (Dwarf_Die & die, Dwarf_Addr pc)
   {
     int res = dwarf_haspc (&die, pc);
@@ -2481,8 +2569,10 @@ struct dwarf_query : public base_query
   bool has_statement_str;
   bool has_function_num;
   bool has_statement_num;
+  bool has_simple_mark;
   string statement_str_val;
   string function_str_val;
+  string simple_mark_str_val;
   Dwarf_Addr statement_num_val;
   Dwarf_Addr function_num_val;
 
@@ -2731,6 +2821,7 @@ dwarf_query::dwarf_query(systemtap_session & sess,
   has_return = has_null_param(params, TOK_RETURN);
   has_maxactive = get_number_param(params, TOK_MAXACTIVE, maxactive_val);
   has_absolute = has_null_param(params, TOK_ABSOLUTE);
+  has_simple_mark = get_string_param(params, TOK_SIMPLE_MARK, simple_mark_str_val);
 
   if (has_function_str)
     spec_type = parse_function_spec(function_str_val);
@@ -2742,10 +2833,31 @@ dwarf_query::dwarf_query(systemtap_session & sess,
   query_done = false;
 }
 
-
 void
 dwarf_query::query_module_dwarf()
 {
+  if (has_simple_mark) {
+    stringstream ss;
+        struct marker_map_data md = dw.find_marker(simple_mark_str_val);
+    if (md.line == -1)
+      {
+	ss << "Failed to find simple_mark(" << simple_mark_str_val << ") in module "
+	   << dw.module_name;
+	throw semantic_error(ss.str());
+      }
+    function = "*";
+    file = md.file;
+    line[0]  = md.line;
+    line[1] =  0;
+    line_type = ABSOLUTE;
+    spec_type = function_file_and_line;
+    has_statement_str = true;
+    ss << "*@" << md.file << ":" << md.line;
+    statement_str_val = ss.str();
+    if (sess.verbose > 1)
+      clog << "transform simple_mark(" << simple_mark_str_val << ") into "
+	   << "statement(" << statement_str_val << endl;
+  }
   if (has_function_num || has_statement_num)
     {
       // If we have module("foo").function(0xbeef) or
@@ -2768,7 +2880,7 @@ dwarf_query::query_module_dwarf()
       // Otherwise if we have a function("foo") or statement("foo")
       // specifier, we have to scan over all the CUs looking for
       // the function(s) in question
-      assert(has_function_str || has_statement_str);
+      assert(has_function_str || has_statement_str || has_simple_mark);
       dw.iterate_over_cus(&query_cu, this);
     }
 }
@@ -4433,7 +4545,12 @@ dwarf_derived_probe::dwarf_derived_probe(const string& funcname,
   else
     fn_or_stmt = "statement";
 
-  if (q.has_function_str || q.has_statement_str)
+  if (q.has_simple_mark)
+    {
+      comps.push_back(new  probe_point::component
+		      (TOK_SIMPLE_MARK, new literal_string(q.simple_mark_str_val)));
+    }
+  else if (q.has_function_str || q.has_statement_str)
       {
         string retro_name = funcname;
 	if (filename != "")
@@ -4507,6 +4624,7 @@ dwarf_derived_probe::register_function_and_statement_variants(match_node * root,
   register_function_variants(root->bind_num(TOK_FUNCTION), dw);
   register_statement_variants(root->bind_str(TOK_STATEMENT), dw);
   register_statement_variants(root->bind_num(TOK_STATEMENT), dw);
+  register_statement_variants(root->bind_str(TOK_SIMPLE_MARK), dw);
 }
 
 void
-- 
1.5.6



