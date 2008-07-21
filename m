Return-Path: <linux-kernel-owner+w=401wt.eu-S1754760AbYGUOUi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754760AbYGUOUi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2008 10:20:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751577AbYGUOU3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Jul 2008 10:20:29 -0400
Received: from accolon.hansenpartnership.com ([76.243.235.52]:43971 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750803AbYGUOU1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2008 10:20:27 -0400
Subject: Re: [RFC] systemtap: begin the process of using proper kernel APIs
	(part1: use kprobe symbol_name/offset instead of address)
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: Masami Hiramatsu <mhiramat@redhat.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>, systemtap@sourceware.org
In-Reply-To: <487FBB56.4070709@redhat.com>
References: <1216146802.3312.95.camel@localhost.localdomain>
	 <487E78ED.30804@redhat.com>
	 <1216249383.3358.69.camel@localhost.localdomain>
	 <487E8CE4.70105@redhat.com>
	 <1216259391.3358.85.camel@localhost.localdomain>
	 <1216304290.5515.11.camel@localhost.localdomain>
	 <1216313914.5515.25.camel@localhost.localdomain>
	 <487FBB56.4070709@redhat.com>
Content-Type: text/plain
Date: Mon, 21 Jul 2008 09:20:18 -0500
Message-Id: <1216650018.3433.12.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 (2.22.3.1-1.fc9) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2008-07-17 at 17:36 -0400, Masami Hiramatsu wrote:
> James Bottomley wrote:
> > On Thu, 2008-07-17 at 09:18 -0500, James Bottomley wrote:
> >> OK, thought about it.  There seem to be two possible solutions
> >>
> >>      1. Get systemtap always to offset from non-static functions.  This
> >>         will use the standard linker to ensure uniqueness (a module
> >>         qualifier will still need to be added to the struct kprobe for
> >>         lookup, since modules can duplicate unexported kernel symbols).
> >>      2. Add the filename as a discriminator for duplicate symbols in the
> >>         kallsyms program (would still need module qualifier).  This is
> >>         appealing because the path name would be printed in the kernel
> >>         trace to help with oops tracking
> >>
> >> This is where negotiations come in.  To me 2. looks to be better because
> >> it will help us with oops tracking.  On the other hand, it's usually
> >> pretty obvious from the stack trace context which files the duplicate
> >> symbols are actually in; what do other people think?
> > 
> > Just by way of illustration, this is systemtap fixed up according to
> > suggestion number 1.  You can see now using your test case that we get:
> > 
> > # probes
> > kernel.function("do_open@fs/block_dev.c:929") /* pc=<lookup_bdev+0x90> */ /* <- kernel.function("do_open") */
> > kernel.function("do_open@fs/nfsctl.c:24") /* pc=<sys_nfsservctl+0x6a> */ /* <- kernel.function("do_open") */
> > kernel.function("do_open@ipc/mqueue.c:642") /* pc=<sys_mq_unlink+0x130> */ /* <- kernel.function("do_open") */
> 
> Hi James,
> 
> Thank you for updating the patch.
> Unfortunately, I found another scenario; if someone make a module which
> has EXPORT_SYMBOL(do_open), it's a non-static function. but there are
> other static version do_open in kallsyms.
> Here, I tested it and got below;
> 
> $ stap --kelf -e 'probe module("test").function("do_open"){}' -p2
> # probes
> module("test").function("do_open@?") /* pc=<do_open+0x0> */ /* <- module("test").function("do_open") */

OK, I fixed this.  It turns out that kprobes already had a syntax for
this problem; it's <module>:<function> (in fact it won't work without
this).  I updated the code (attached below) to work correctly.  I'm
still looking at the kallsyms code for a uniqueness solution.

James

---

From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Part1 use symbol_name/offset to locate dwarf probes

---
 tapsets.cxx |  120 ++++++++++++++++++++++++++++++++++++++++------------------
 1 files changed, 83 insertions(+), 37 deletions(-)

diff --git a/tapsets.cxx b/tapsets.cxx
index a08a8ab..f24dc10 100644
--- a/tapsets.cxx
+++ b/tapsets.cxx
@@ -491,6 +491,7 @@ func_info
   Dwarf_Addr entrypc;
   Dwarf_Addr prologue_end;
   bool weak;
+  bool global;
   // Comparison functor for list of functions sorted by address. The
   // two versions that take a Dwarf_Addr let us use the STL algorithms
   // upper_bound, equal_range et al., but we don't know whether the
@@ -591,6 +592,7 @@ symbol_table
   module_info *mod_info;	// associated module
   map<string, func_info*> map_by_name;
   vector<func_info*> list_by_addr;
+  vector<func_info*> global_list_by_addr;
   typedef vector<func_info*>::iterator iterator_t;
   typedef pair<iterator_t, iterator_t> range_t;
 #ifdef __powerpc__
@@ -598,7 +600,7 @@ symbol_table
 #endif
   // add_symbol doesn't leave symbol table in order; call
   // symbol_table::sort() when done adding symbols.
-  void add_symbol(const char *name, bool weak, Dwarf_Addr addr,
+  void add_symbol(const char *name, bool weak, bool global, Dwarf_Addr addr,
                                                Dwarf_Addr *high_addr);
   void sort();
   enum info_status read_symbols(FILE *f, const string& path);
@@ -611,7 +613,7 @@ symbol_table
   void purge_syscall_stubs();
   func_info *lookup_symbol(const string& name);
   Dwarf_Addr lookup_symbol_address(const string& name);
-  func_info *get_func_containing_address(Dwarf_Addr addr);
+  func_info *get_func_containing_address(Dwarf_Addr addr, bool global);
 
   symbol_table(module_info *mi) : mod_info(mi) {}
   ~symbol_table();
@@ -2309,13 +2311,15 @@ struct dwarf_derived_probe: public derived_probe
                        const string& module,
                        const string& section,
 		       Dwarf_Addr dwfl_addr,
-		       Dwarf_Addr addr,
+		       string symbol,
+		       unsigned int offset,
 		       dwarf_query & q,
                        Dwarf_Die* scope_die);
 
   string module;
   string section;
-  Dwarf_Addr addr;
+  string kprobe_symbol;
+  unsigned int kprobe_offset;
   bool has_return;
   bool has_maxactive;
   long maxactive_val;
@@ -2840,7 +2844,7 @@ dwarf_query::query_module_symtab()
       // Find the "function" in which the indicated address resides.
       Dwarf_Addr addr =
       		(has_function_num ? function_num_val : statement_num_val);
-      fi = sym_table->get_func_containing_address(addr);
+      fi = sym_table->get_func_containing_address(addr, false);
       if (!fi)
         {
           cerr << "Warning: address "
@@ -3265,9 +3269,18 @@ dwarf_query::add_probe_point(const string& funcname,
 
   if (! bad)
     {
+      struct module_info *mi = dw.mod_info;
+      if (!mi->sym_table)
+	mi->get_symtab(this);
+      struct symbol_table *sym_tab = mi->sym_table;
+      func_info *symbol = sym_tab->get_func_containing_address(addr, true);
+
       sess.unwindsym_modules.insert (module);
       probe = new dwarf_derived_probe(funcname, filename, line,
-                                      module, reloc_section, addr, reloc_addr, *this, scope_die);
+                                      module, reloc_section, reloc_addr,
+				      symbol->name,
+				      (unsigned int)(addr - symbol->addr),
+				      *this, scope_die);
       results.push_back(probe);
     }
 }
@@ -4385,7 +4398,8 @@ dwarf_derived_probe::printsig (ostream& o) const
   // function instances.  This is distinct from the verbose/clog
   // output, since this part goes into the cache hash calculations.
   sole_location()->print (o);
-  o << " /* pc=0x" << hex << addr << dec << " */";
+  o << " /* pc=<" << kprobe_symbol << "+0x" << hex
+    << kprobe_offset << dec << "> */";
   printsig_nested (o);
 }
 
@@ -4411,22 +4425,26 @@ dwarf_derived_probe::dwarf_derived_probe(const string& funcname,
                                          // NB: dwfl_addr is the virtualized
                                          // address for this symbol.
                                          Dwarf_Addr dwfl_addr,
-                                         // addr is the section-offset for
-                                         // actual relocation.
-                                         Dwarf_Addr addr,
+                                         // symbol is the closest known symbol
+                                         // and offset is the offset from the symbol
+					 string symbol,
+					 unsigned int offset,
                                          dwarf_query& q,
                                          Dwarf_Die* scope_die /* may be null */)
   : derived_probe (q.base_probe, new probe_point(*q.base_loc) /* .components soon rewritten */ ),
-    module (module), section (section), addr (addr),
+    module (module), section (section), kprobe_symbol(symbol),
+    kprobe_offset(offset),
     has_return (q.has_return),
     has_maxactive (q.has_maxactive),
     maxactive_val (q.maxactive_val)
 {
   // Assert relocation invariants
+#if 0
   if (section == "" && dwfl_addr != addr) // addr should be absolute
     throw semantic_error ("missing relocation base against", q.base_loc->tok);
   if (section != "" && dwfl_addr == addr) // addr should be an offset
     throw semantic_error ("inconsistent relocation address", q.base_loc->tok);
+#endif
 
   this->tok = q.base_probe->tok;
 
@@ -4634,8 +4652,8 @@ dwarf_derived_probe_group::emit_module_decls (systemtap_session& s)
   // Let's find some stats for the three embedded strings.  Maybe they
   // are small and uniform enough to justify putting char[MAX]'s into
   // the array instead of relocated char*'s.
-  size_t module_name_max = 0, section_name_max = 0, pp_name_max = 0;
-  size_t module_name_tot = 0, section_name_tot = 0, pp_name_tot = 0;
+  size_t pp_name_max = 0, pp_name_tot = 0;
+  size_t symbol_name_name_max  = 0, symbol_name_name_tot = 0;
   size_t all_name_cnt = probes_by_module.size(); // for average
   for (p_b_m_iterator it = probes_by_module.begin(); it != probes_by_module.end(); it++)
     {
@@ -4644,9 +4662,8 @@ dwarf_derived_probe_group::emit_module_decls (systemtap_session& s)
         size_t var##_size = (expr) + 1;                 \
         var##_max = max (var##_max, var##_size);        \
         var##_tot += var##_size; } while (0)
-      DOIT(module_name, p->module.size());
-      DOIT(section_name, p->section.size());
       DOIT(pp_name, lex_cast_qstring(*p->sole_location()).size());
+      DOIT(symbol_name_name, p->kprobe_symbol.size());
 #undef DOIT
     }
 
@@ -4666,11 +4683,10 @@ dwarf_derived_probe_group::emit_module_decls (systemtap_session& s)
       if (s.verbose > 2) clog << "stap_dwarf_probe *" << #var << endl;  \
     }
 
-  CALCIT(module);
-  CALCIT(section);
   CALCIT(pp);
+  CALCIT(symbol_name);
 
-  s.op->newline() << "const unsigned long address;";
+  s.op->newline() << "unsigned int offset;";
   s.op->newline() << "void (* const ph) (struct context*);";
   s.op->newline(-1) << "} stap_dwarf_probes[] = {";
   s.op->indent(1);
@@ -4687,9 +4703,8 @@ dwarf_derived_probe_group::emit_module_decls (systemtap_session& s)
           assert (p->maxactive_val >= 0 && p->maxactive_val <= USHRT_MAX);
           s.op->line() << " .maxactive_val=" << p->maxactive_val << ",";
         }
-      s.op->line() << " .address=0x" << hex << p->addr << dec << "UL,";
-      s.op->line() << " .module=\"" << p->module << "\",";
-      s.op->line() << " .section=\"" << p->section << "\",";
+      s.op->line() << " .symbol_name=\"" << p->kprobe_symbol << "\",";
+      s.op->line() << " .offset=0x" << hex << p->kprobe_offset << dec << ",";
       s.op->line() << " .pp=" << lex_cast_qstring (*p->sole_location()) << ",";
       s.op->line() << " .ph=&" << p->name;
       s.op->line() << " },";
@@ -4749,11 +4764,10 @@ dwarf_derived_probe_group::emit_module_init (systemtap_session& s)
   s.op->newline() << "for (i=0; i<" << probes_by_module.size() << "; i++) {";
   s.op->newline(1) << "struct stap_dwarf_probe *sdp = & stap_dwarf_probes[i];";
   s.op->newline() << "struct stap_dwarf_kprobe *kp = & stap_dwarf_kprobes[i];";
-  s.op->newline() << "unsigned long relocated_addr = _stp_module_relocate (sdp->module, sdp->section, sdp->address);";
-  s.op->newline() << "if (relocated_addr == 0) continue;"; // quietly; assume module is absent
   s.op->newline() << "probe_point = sdp->pp;";
   s.op->newline() << "if (sdp->return_p) {";
-  s.op->newline(1) << "kp->u.krp.kp.addr = (void *) relocated_addr;";
+  s.op->newline(1) << "kp->u.krp.kp.symbol_name = sdp->symbol_name;";
+  s.op->newline(1) << "kp->u.krp.kp.offset = sdp->offset;";
   s.op->newline() << "if (sdp->maxactive_p) {";
   s.op->newline(1) << "kp->u.krp.maxactive = sdp->maxactive_val;";
   s.op->newline(-1) << "} else {";
@@ -4774,8 +4788,8 @@ dwarf_derived_probe_group::emit_module_init (systemtap_session& s)
   s.op->newline() << "rc = register_kretprobe (& kp->u.krp);";
   s.op->newline() << "#endif";
   s.op->newline(-1) << "} else {";
-  // to ensure safeness of bspcache, always use aggr_kprobe on ia64
-  s.op->newline(1) << "kp->u.kp.addr = (void *) relocated_addr;";
+  s.op->newline(1) << "kp->u.krp.kp.symbol_name = sdp->symbol_name;";
+  s.op->newline(1) << "kp->u.krp.kp.offset = sdp->offset;";
   s.op->newline() << "kp->u.kp.pre_handler = &enter_kprobe_probe;";
   s.op->newline() << "#ifdef __ia64__";
   s.op->newline() << "kp->dummy.addr = kp->u.kp.addr;";
@@ -4939,12 +4953,20 @@ dwarf_builder::build(systemtap_session & sess,
           throw semantic_error ("absolute statement probe in unprivileged script", q.base_probe->tok);
         }
 
+      struct module_info *mi = dw->mod_info;
+      if (!mi->sym_table)
+	mi->get_symtab(&q);
+      struct symbol_table *sym_tab = mi->sym_table;
+      func_info *symbol = sym_tab->get_func_containing_address(q.statement_num_val, true);
+
       // For kernel.statement(NUM).absolute probe points, we bypass
       // all the debuginfo stuff: We just wire up a
       // dwarf_derived_probe right here and now.
       dwarf_derived_probe* p =
         new dwarf_derived_probe ("", "", 0, "kernel", "",
-                                 q.statement_num_val, q.statement_num_val,
+                                 q.statement_num_val,
+				 symbol->name,
+				 (unsigned int)(q.statement_num_val - symbol->addr),
                                  q, 0);
       finished_results.push_back (p);
       sess.unwindsym_modules.insert ("kernel");
@@ -4962,8 +4984,8 @@ symbol_table::~symbol_table()
 }
 
 void
-symbol_table::add_symbol(const char *name, bool weak, Dwarf_Addr addr,
-                                                      Dwarf_Addr *high_addr)
+symbol_table::add_symbol(const char *name, bool weak, bool global, 
+			 Dwarf_Addr addr, Dwarf_Addr *high_addr)
 {
 #ifdef __powerpc__
   // Map ".sys_foo" to "sys_foo".
@@ -4974,10 +4996,13 @@ symbol_table::add_symbol(const char *name, bool weak, Dwarf_Addr addr,
   fi->addr = addr;
   fi->name = name;
   fi->weak = weak;
+  fi->global = global;
   map_by_name[fi->name] = fi;
   // TODO: Use a multimap in case there are multiple static
   // functions with the same name?
   list_by_addr.push_back(fi);
+  if (global)
+    global_list_by_addr.push_back(fi);
 }
 
 enum info_status
@@ -5015,7 +5040,8 @@ symbol_table::read_symbols(FILE *f, const string& path)
           break;
         }
       if (type == 'T' || type == 't' || type == 'W')
-        add_symbol(name, (type == 'W'), (Dwarf_Addr) addr, &high_addr);
+        add_symbol(name, (type == 'W'), (type == 'T'),
+		   (Dwarf_Addr) addr, &high_addr);
     }
 
   if (list_by_addr.size() < 1)
@@ -5134,7 +5160,8 @@ symbol_table::get_from_elf()
       if (name && GELF_ST_TYPE(sym.st_info) == STT_FUNC &&
                                                    !reject_section(section))
         add_symbol(name, (GELF_ST_BIND(sym.st_info) == STB_WEAK),
-                                              sym.st_value, &high_addr);
+		   GELF_ST_BIND(sym.st_info) == STB_GLOBAL,
+		   sym.st_value, &high_addr);
     }
   sort();
   return info_present;
@@ -5175,14 +5202,29 @@ symbol_table::mark_dwarf_redundancies(dwflpp *dw)
 }
 
 func_info *
-symbol_table::get_func_containing_address(Dwarf_Addr addr)
+symbol_table::get_func_containing_address(Dwarf_Addr addr, bool global)
 {
-  iterator_t iter = upper_bound(list_by_addr.begin(), list_by_addr.end(), addr,
-                              func_info::Compare());
-  if (iter == list_by_addr.begin())
-    return NULL;
+  iterator_t iter;
+
+  if (global)
+    {
+      iter = upper_bound(global_list_by_addr.begin(),
+			 global_list_by_addr.end(), addr,
+			 func_info::Compare());
+      if (iter == global_list_by_addr.begin())
+	return NULL;
+      else
+	return *(iter - 1);
+    }
   else
-    return *(iter - 1);
+    {
+      iter = upper_bound(list_by_addr.begin(), list_by_addr.end(), addr,
+			 func_info::Compare());
+      if (iter == list_by_addr.begin())
+	return NULL;
+      else
+	return *(iter - 1);
+    }
 }
 
 func_info *
@@ -5235,12 +5277,16 @@ symbol_table::purge_syscall_stubs()
   list_by_addr.erase(remove(purge_range.first, purge_range.second,
                             (func_info*)0),
                      purge_range.second);
+  // NOTE: At the moment global_list_by_addr has no weak symbols
+  // so nothing needs to be removed from it.
 }
 
 void
 symbol_table::sort()
 {
   stable_sort(list_by_addr.begin(), list_by_addr.end(), func_info::Compare());
+  stable_sort(global_list_by_addr.begin(), global_list_by_addr.end(),
+	      func_info::Compare());
 }
 
 void
-- 
1.5.6.2



