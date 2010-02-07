Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756031Ab0BGVFd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Feb 2010 16:05:33 -0500
Received: from moutng.kundenserver.de ([212.227.126.171]:60895 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753948Ab0BGVFc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Feb 2010 16:05:32 -0500
From: Bernhard Schiffner <bernhard@schiffner-limbach.de>
To: Larry Finger <Larry.Finger@lwfinger.net>, linux-kernel@vger.kernel.org
Subject: [mmiotrace] Make timestamps as printk() does.
Date: Sun, 7 Feb 2010 22:05:26 +0100
User-Agent: KMail/1.12.4 (Linux/2.6.32.7-0.1-desktop; KDE/4.3.5; i686; ; )
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201002072205.26665.bernhard@schiffner-limbach.de>
X-Provags-ID: V01U2FsdGVkX1/6iEP7viBHmZQeTGUzyzCuzZqiFwP3lu/1WaO
 +ATy7S44pNiYp5fgh225qOcX6PlZiX+4SJjX2bKQN7mA83KtPt
 gYTzCr+b5dGGRsso5AKfg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hallo,

this little patch makes a simple "sort -m" on output gotten from dmesg and  
mmiotrace possible.
It's a real help at least for me.

Bernhard
(CC me please, I'am not on this list.)

------------
    Make mmiotrace timestamps compareable to printk().

diff --git a/kernel/trace/trace_mmiotrace.c b/kernel/trace/trace_mmiotrace.c
index 0acd834..32c21f7 100644                                               
--- a/kernel/trace/trace_mmiotrace.c                                        
+++ b/kernel/trace/trace_mmiotrace.c                                        
@@ -146,7 +146,7 @@ static ssize_t mmio_read(struct trace_iterator *iter, 
struct file *filp,
        n = count_overruns(iter);                                                           
        if (n) {                                                                            
                /* XXX: This is later than where events were lost. */                       
-               trace_seq_printf(s, "MARK 0.000000 Lost %lu events.\n", n);                 
+               trace_seq_printf(s, "[    0.000000] MARK Lost %lu events.\n", 
n);           
                if (!overrun_detected)                                                      
                        pr_warning("mmiotrace has lost events.\n");                         
                overrun_detected = true;                                                    
@@ -186,21 +186,21 @@ static enum print_line_t mmio_print_rw(struct 
trace_iterator *iter)   
        switch (rw->opcode) {                                                               
        case MMIO_READ:                                                                     
                ret = trace_seq_printf(s,                                                   
-                       "R %d %u.%06lu %d 0x%llx 0x%lx 0x%lx %d\n",                         
-                       rw->width, secs, usec_rem, rw->map_id,                              
+                       "[%5lu.%06lu] R %d %d 0x%llx 0x%lx 0x%lx %d\n",                     
+                       secs, usec_rem, rw->width, rw->map_id,                              
                        (unsigned long long)rw->phys,                                       
                        rw->value, rw->pc, 0);                                              
                break;                                                                      
        case MMIO_WRITE:                                                                    
                ret = trace_seq_printf(s,                                                   
-                       "W %d %u.%06lu %d 0x%llx 0x%lx 0x%lx %d\n",                         
-                       rw->width, secs, usec_rem, rw->map_id,                              
+                       "[%5lu.%06lu] W %d %d 0x%llx 0x%lx 0x%lx %d\n",                     
+                       secs, usec_rem, rw->width, rw->map_id,                              
                        (unsigned long long)rw->phys,                                       
                        rw->value, rw->pc, 0);                                              
                break;                                                                      
        case MMIO_UNKNOWN_OP:
                ret = trace_seq_printf(s,
-                       "UNKNOWN %u.%06lu %d 0x%llx %02lx,%02lx,"
+                       "[%5lu.%06lu] UNKNOWN %d 0x%llx %02lx,%02lx,"
                        "%02lx 0x%lx %d\n",
                        secs, usec_rem, rw->map_id,
                        (unsigned long long)rw->phys,
@@ -233,14 +233,14 @@ static enum print_line_t mmio_print_map(struct 
trace_iterator *iter)
        switch (m->opcode) {
        case MMIO_PROBE:
                ret = trace_seq_printf(s,
-                       "MAP %u.%06lu %d 0x%llx 0x%lx 0x%lx 0x%lx %d\n",
+                       "[%5lu.%06lu] MAP %d 0x%llx 0x%lx 0x%lx 0x%lx %d\n",
                        secs, usec_rem, m->map_id,
                        (unsigned long long)m->phys, m->virt, m->len,
                        0UL, 0);
                break;
        case MMIO_UNPROBE:
                ret = trace_seq_printf(s,
-                       "UNMAP %u.%06lu %d 0x%lx %d\n",
+                       "[%5lu.%06lu] UNMAP %d 0x%lx %d\n",
                        secs, usec_rem, m->map_id, 0UL, 0);
                break;
        default:
@@ -264,7 +264,7 @@ static enum print_line_t mmio_print_mark(struct 
trace_iterator *iter)
        int ret;

        /* The trailing newline must be in the message. */
-       ret = trace_seq_printf(s, "MARK %u.%06lu %s", secs, usec_rem, msg);
+       ret = trace_seq_printf(s, "[%5lu.%06lu] MARK %s", secs, usec_rem, 
msg);
        if (!ret)
                return TRACE_TYPE_PARTIAL_LINE;






