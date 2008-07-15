Return-Path: <linux-kernel-owner+w=401wt.eu-S1758428AbYGOSdg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758428AbYGOSdg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2008 14:33:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753767AbYGOSd1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jul 2008 14:33:27 -0400
Received: from accolon.hansenpartnership.com ([76.243.235.52]:57802 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753025AbYGOSd0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2008 14:33:26 -0400
Subject: [RFC] systemtap: begin the process of using proper kernel APIs
	(part1: use kprobe symbol_name/offset instead of address)
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: linux-kernel <linux-kernel@vger.kernel.org>, systemtap@sourceware.org
Content-Type: text/plain
Date: Tue, 15 Jul 2008 13:33:22 -0500
Message-Id: <1216146802.3312.95.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 (2.22.3.1-1.fc9) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

One of the big nasties of systemtap is the way it tries to embed
virtually the entirety of the kernel symbol table in the probe modules
it constructs.  This is highly undesirable because it represents a
subversion of the kernel API to gain access to unexported symbols.  At
least for kprobes, the correct way to do this is to specify the probe
point by symbol and offset.

This patch converts systemtap to use the correct kprobe
symbol_name/offset pair to identify the probe location.

This only represents a baby step:  after this is done, there are at
least three other consumers of the systemtap module relocation
machinery:

     1. unwind information.  I think the consumers of this can be
        converted to use the arch specific unwinders that already exist
        within the kernel
     2. systemtap specific functions that use kernel internals.  This
        was things like get_cycles() but I think they all now use a
        sanctioned API ... need to check
     3. Access to unexported global variables used by the probes.  This
        one is a bit tricky; the dwarf gives a probe the ability to
        access any variable available from the probed stack frame,
        including all globals.  We could just make the globals off
        limits, but that weakens the value of the debugger.
        Alternatively, we could expand the kprobe API to allow probes
        access to named global variables (tricky to get right without
        effectively giving general symbol access).  Thoughts?

If you're going to try this out, you currently need to specify --kelf on
the command line to tell systemtap to use the kernel elf to derive
symbol names and offsets (it will just segfault without this ATM).

James

---

diff --git a/tapsets.cxx b/tapsets.cxx
index 9037e15..a6a6dd3 100644
--- a/tapsets.cxx
+++ b/tapsets.cxx
@@ -2306,13 +2306,15 @@ struct dwarf_derived_probe: public derived_probe
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
@@ -3260,9 +3262,18 @@ dwarf_query::add_probe_point(const string& funcname,
 
   if (! bad)
     {
+      struct module_info *mi = dw.mod_info;
+      if (!mi->sym_table)
+	mi->get_symtab(this);
+      struct symbol_table *sym_tab = mi->sym_table;
+      func_info *symbol = sym_tab->get_func_containing_address(addr);
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
@@ -4380,7 +4391,8 @@ dwarf_derived_probe::printsig (ostream& o) const
   // function instances.  This is distinct from the verbose/clog
   // output, since this part goes into the cache hash calculations.
   sole_location()->print (o);
-  o << " /* pc=0x" << hex << addr << dec << " */";
+  o << " /* pc=<" << kprobe_symbol << "+0x" << hex 
+    << kprobe_offset << dec << "> */";
   printsig_nested (o);
 }
 
@@ -4406,22 +4418,26 @@ dwarf_derived_probe::dwarf_derived_probe(const string& funcname,
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
 
@@ -4620,8 +4636,8 @@ dwarf_derived_probe_group::emit_module_decls (systemtap_session& s)
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
@@ -4630,9 +4646,8 @@ dwarf_derived_probe_group::emit_module_decls (systemtap_session& s)
         size_t var##_size = (expr) + 1;                 \
         var##_max = max (var##_max, var##_size);        \
         var##_tot += var##_size; } while (0)
-      DOIT(module_name, p->module.size());
-      DOIT(section_name, p->section.size());
       DOIT(pp_name, lex_cast_qstring(*p->sole_location()).size());
+      DOIT(symbol_name_name, p->kprobe_symbol.size());
 #undef DOIT
     }
 
@@ -4652,11 +4667,10 @@ dwarf_derived_probe_group::emit_module_decls (systemtap_session& s)
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
@@ -4673,9 +4687,8 @@ dwarf_derived_probe_group::emit_module_decls (systemtap_session& s)
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
@@ -4735,11 +4748,10 @@ dwarf_derived_probe_group::emit_module_init (systemtap_session& s)
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
@@ -4748,7 +4760,8 @@ dwarf_derived_probe_group::emit_module_init (systemtap_session& s)
   s.op->newline() << "kp->u.krp.handler = &enter_kretprobe_probe;";
   s.op->newline() << "rc = register_kretprobe (& kp->u.krp);";
   s.op->newline(-1) << "} else {";
-  s.op->newline(1) << "kp->u.kp.addr = (void *) relocated_addr;";
+  s.op->newline(1) << "kp->u.krp.kp.symbol_name = sdp->symbol_name;";
+  s.op->newline(1) << "kp->u.krp.kp.offset = sdp->offset;";
   s.op->newline() << "kp->u.kp.pre_handler = &enter_kprobe_probe;";
   s.op->newline() << "rc = register_kprobe (& kp->u.kp);";
   s.op->newline(-1) << "}";
@@ -4885,12 +4898,20 @@ dwarf_builder::build(systemtap_session & sess,
           throw semantic_error ("absolute statement probe in unprivileged script", q.base_probe->tok);
         }
 
+      struct module_info *mi = dw->mod_info;
+      if (!mi->sym_table)
+	mi->get_symtab(&q);
+      struct symbol_table *sym_tab = mi->sym_table;
+      func_info *symbol = sym_tab->get_func_containing_address(q.statement_num_val);
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


