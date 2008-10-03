Return-Path: <linux-kernel-owner+w=401wt.eu-S1751949AbYJCNjh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751949AbYJCNjh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2008 09:39:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751284AbYJCNj0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Oct 2008 09:39:26 -0400
Received: from fg-out-1718.google.com ([72.14.220.153]:26093 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752722AbYJCNjZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2008 09:39:25 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :content-type;
        b=ZcaPv5Mgq0+hQMC9YaDOEnByOahZwn/evsK0U37s0NJ99HiBo5pDWH1GNKvDytlQI/
         FeFzlhrcGm+1wjqO0ZWu74yvECU/cnHo8x01xXuM3OOQCMBNbV9ffJWpxAMYiIN97oH/
         Goo5SZWlvJqsbck+08d02B9eN1qsl9bmMuUJI=
Message-ID: <48E62089.7050006@gmail.com>
Date: Fri, 03 Oct 2008 15:39:21 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
User-Agent: Thunderbird 2.0.0.16 (X11/20080724)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: linux-kernel@vger.kernel.org, Arjan van de Ven <arjan@infradead.org>
Subject: [PATCH -tip] Tracing/fastboot: Only trace non-module initcalls
Content-Type: multipart/mixed;
 boundary="------------070209020208050606010204"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------070209020208050606010204
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

At this time, only built-in initcalls interest us.
We can't really produce a relevant graph if we include
the modules initcall too.

I had good results after this patch (see svg in attachment).

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
---
 include/linux/ftrace.h    |    2 ++
 init/main.c               |    1 +
 kernel/trace/trace_boot.c |   11 ++++++++---
 3 files changed, 11 insertions(+), 3 deletions(-)

diff --git a/include/linux/ftrace.h b/include/linux/ftrace.h
index ed53265..5812dba 100644
--- a/include/linux/ftrace.h
+++ b/include/linux/ftrace.h
@@ -225,9 +225,11 @@ struct boot_trace {
 #ifdef CONFIG_BOOT_TRACER
 extern void trace_boot(struct boot_trace *it, initcall_t fn);
 extern void start_boot_trace(void);
+extern void stop_boot_trace(void);
 #else
 static inline void trace_boot(struct boot_trace *it, initcall_t fn) { }
 static inline void start_boot_trace(void) { }
+static inline void stop_boot_trace(void) { }
 #endif
 
 
diff --git a/init/main.c b/init/main.c
index 47d621a..2e5c37e 100644
--- a/init/main.c
+++ b/init/main.c
@@ -976,6 +976,7 @@ static int __init kernel_init(void * unused)
 	 * we're essentially up and running. Get rid of the
 	 * initmem segments and start the user-mode stuff..
 	 */
+	stop_boot_trace();
 	init_post();
 	return 0;
 }
diff --git a/kernel/trace/trace_boot.c b/kernel/trace/trace_boot.c
index b9dc2c0..a7efe35 100644
--- a/kernel/trace/trace_boot.c
+++ b/kernel/trace/trace_boot.c
@@ -22,11 +22,16 @@ void start_boot_trace(void)
 	trace_boot_enabled = 1;
 }
 
-void stop_boot_trace(struct trace_array *tr)
+void stop_boot_trace(void)
 {
 	trace_boot_enabled = 0;
 }
 
+void reset_boot_trace(struct trace_array *tr)
+{
+	stop_boot_trace();
+}
+
 static void boot_trace_init(struct trace_array *tr)
 {
 	int cpu;
@@ -43,7 +48,7 @@ static void boot_trace_ctrl_update(struct trace_array *tr)
 	if (tr->ctrl)
 		start_boot_trace();
 	else
-		stop_boot_trace(tr);
+		stop_boot_trace();
 }
 
 static enum print_line_t initcall_print_line(struct trace_iterator *iter)
@@ -81,7 +86,7 @@ struct tracer boot_tracer __read_mostly =
 {
 	.name		= "initcall",
 	.init		= boot_trace_init,
-	.reset		= stop_boot_trace,
+	.reset		= reset_boot_trace,
 	.ctrl_update	= boot_trace_ctrl_update,
 	.print_line	= initcall_print_line,
 };

--------------070209020208050606010204
Content-Type: image/svg+xml;
 name="boot.svg"
Content-Transfer-Encoding: base64
Content-Disposition: inline;
 filename="boot.svg"

PD94bWwgdmVyc2lvbj0iMS4wIiBzdGFuZGFsb25lPSJubyI/PiAKPHN2ZyB3aWR0aD0iMTAw
MCIgaGVpZ2h0PSIxMDAlIiB2ZXJzaW9uPSIxLjEiIHhtbG5zPSJodHRwOi8vd3d3LnczLm9y
Zy8yMDAwL3N2ZyI+CjxyZWN0IHg9IjM2Mi45MTE2NTkyNzU3OTkiIHdpZHRoPSI1MTQuOTk1
NzIzMjI4OTkxIiB5PSIxNTAiIGhlaWdodD0iMTQ1IiBzdHlsZT0iZmlsbDpyZ2IoMCwwLDI1
NSk7ZmlsbC1vcGFjaXR5OjAuNTtzdHJva2Utd2lkdGg6MTtzdHJva2U6cmdiKDAsMCwwKSIv
Pgo8dGV4dCB0cmFuc2Zvcm09InRyYW5zbGF0ZSgzNjguOTExNjU5Mjc1Nzk5LDE1NCkgcm90
YXRlKDkwKSI+aWRlX2dlbmVyaWNfaW5pdDwvdGV4dD4KPHJlY3QgeD0iMjk3LjQ0MTI4MjE0
MDk0IiB3aWR0aD0iMjAuMTExODY2MTA1MTUzOSIgeT0iMTUwIiBoZWlnaHQ9IjE0NSIgc3R5
bGU9ImZpbGw6cmdiKDAsMjU1LDApO2ZpbGwtb3BhY2l0eTowLjU7c3Ryb2tlLXdpZHRoOjE7
c3Ryb2tlOnJnYigwLDAsMCkiLz4KPHRleHQgdHJhbnNmb3JtPSJ0cmFuc2xhdGUoMzAzLjQ0
MTI4MjE0MDk0LDE1NCkgcm90YXRlKDkwKSI+dWlkX2NhY2hlX2luaXQ8L3RleHQ+CjxyZWN0
IHg9IjIxNS45NTE0MzkzMjU0OCIgd2lkdGg9IjE3LjY2OTUwMjQzNzM4NzUiIHk9IjE1MCIg
aGVpZ2h0PSIxNDUiIHN0eWxlPSJmaWxsOnJnYigyNTUsMCwyMCk7ZmlsbC1vcGFjaXR5OjAu
NTtzdHJva2Utd2lkdGg6MTtzdHJva2U6cmdiKDAsMCwwKSIvPgo8dGV4dCB0cmFuc2Zvcm09
InRyYW5zbGF0ZSgyMjEuOTUxNDM5MzI1NDgsMTU0KSByb3RhdGUoOTApIj50dHlfaW5pdDwv
dGV4dD4KPHJlY3QgeD0iMjM0LjI1ODQ5MTcxNzY4MSIgd2lkdGg9Ijg2LjUyNjU2OTQyMTQ5
NDYiIHk9IjE1MCIgaGVpZ2h0PSIxNDUiIHN0eWxlPSJmaWxsOnJnYigyNTUsMjU1LDIwKTtm
aWxsLW9wYWNpdHk6MC41O3N0cm9rZS13aWR0aDoxO3N0cm9rZTpyZ2IoMCwwLDApIi8+Cjx0
ZXh0IHRyYW5zZm9ybT0idHJhbnNsYXRlKDI0MC4yNTg0OTE3MTc2ODEsMTU0KSByb3RhdGUo
OTApIj5wdHlfaW5pdDwvdGV4dD4KPHJlY3QgeD0iMTY1LjgyNjcxNDQ5MTk0NyIgd2lkdGg9
IjE1Ljg2NDI4OTMyNDU3MiIgeT0iMTUwIiBoZWlnaHQ9IjE0NSIgc3R5bGU9ImZpbGw6cmdi
KDI1NSwwLDI1NSk7ZmlsbC1vcGFjaXR5OjAuNTtzdHJva2Utd2lkdGg6MTtzdHJva2U6cmdi
KDAsMCwwKSIvPgo8dGV4dCB0cmFuc2Zvcm09InRyYW5zbGF0ZSgxNzEuODI2NzE0NDkxOTQ3
LDE1NCkgcm90YXRlKDkwKSI+c2xhYl9zeXNmc19pbml0PC90ZXh0Pgo8cmVjdCB4PSI4Nzku
ODI0OTcwOTgwMjI2IiB3aWR0aD0iMjUuMDI4ODMyNzUzMDQyMSIgeT0iMTUwIiBoZWlnaHQ9
IjE0NSIgc3R5bGU9ImZpbGw6cmdiKDAsMjU1LDI1NSk7ZmlsbC1vcGFjaXR5OjAuNTtzdHJv
a2Utd2lkdGg6MTtzdHJva2U6cmdiKDAsMCwwKSIvPgo8dGV4dCB0cmFuc2Zvcm09InRyYW5z
bGF0ZSg4ODUuODI0OTcwOTgwMjI2LDE1NCkgcm90YXRlKDkwKSI+aWRlZGlza19pbml0PC90
ZXh0Pgo8dGV4dCB0cmFuc2Zvcm09InRyYW5zbGF0ZSgwLDg5KSByb3RhdGUoOTApIj4wLjU8
L3RleHQ+Cjx0ZXh0IHRyYW5zZm9ybT0idHJhbnNsYXRlKDYzLjMzMzMzMzMzMzMzMzMsODkp
IHJvdGF0ZSg5MCkiPjAuNzg8L3RleHQ+Cjx0ZXh0IHRyYW5zZm9ybT0idHJhbnNsYXRlKDEy
Ni42NjY2NjY2NjY2NjcsODkpIHJvdGF0ZSg5MCkiPjEuMDY8L3RleHQ+Cjx0ZXh0IHRyYW5z
Zm9ybT0idHJhbnNsYXRlKDE5MCw4OSkgcm90YXRlKDkwKSI+MS4zNDwvdGV4dD4KPHRleHQg
dHJhbnNmb3JtPSJ0cmFuc2xhdGUoMjUzLjMzMzMzMzMzMzMzMyw4OSkgcm90YXRlKDkwKSI+
MS42MjwvdGV4dD4KPHRleHQgdHJhbnNmb3JtPSJ0cmFuc2xhdGUoMzE2LjY2NjY2NjY2NjY2
Nyw4OSkgcm90YXRlKDkwKSI+MS45PC90ZXh0Pgo8dGV4dCB0cmFuc2Zvcm09InRyYW5zbGF0
ZSgzODAsODkpIHJvdGF0ZSg5MCkiPjIuMTg8L3RleHQ+Cjx0ZXh0IHRyYW5zZm9ybT0idHJh
bnNsYXRlKDQ0My4zMzMzMzMzMzMzMzMsODkpIHJvdGF0ZSg5MCkiPjIuNDY8L3RleHQ+Cjx0
ZXh0IHRyYW5zZm9ybT0idHJhbnNsYXRlKDUwNi42NjY2NjY2NjY2NjcsODkpIHJvdGF0ZSg5
MCkiPjIuNzQ8L3RleHQ+Cjx0ZXh0IHRyYW5zZm9ybT0idHJhbnNsYXRlKDU3MCw4OSkgcm90
YXRlKDkwKSI+My4wMjwvdGV4dD4KPHRleHQgdHJhbnNmb3JtPSJ0cmFuc2xhdGUoNjMzLjMz
MzMzMzMzMzMzMyw4OSkgcm90YXRlKDkwKSI+My4zPC90ZXh0Pgo8dGV4dCB0cmFuc2Zvcm09
InRyYW5zbGF0ZSg2OTYuNjY2NjY2NjY2NjY3LDg5KSByb3RhdGUoOTApIj4zLjU4PC90ZXh0
Pgo8dGV4dCB0cmFuc2Zvcm09InRyYW5zbGF0ZSg3NjAsODkpIHJvdGF0ZSg5MCkiPjMuODY8
L3RleHQ+Cjx0ZXh0IHRyYW5zZm9ybT0idHJhbnNsYXRlKDgyMy4zMzMzMzMzMzMzMzMsODkp
IHJvdGF0ZSg5MCkiPjQuMTQ8L3RleHQ+Cjx0ZXh0IHRyYW5zZm9ybT0idHJhbnNsYXRlKDg4
Ni42NjY2NjY2NjY2NjcsODkpIHJvdGF0ZSg5MCkiPjQuNDI8L3RleHQ+Cjwvc3ZnPgo=
--------------070209020208050606010204--
