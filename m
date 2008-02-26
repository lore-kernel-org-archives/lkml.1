Return-Path: <linux-kernel-owner+w=401wt.eu-S1754531AbYBZMk3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754531AbYBZMk3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2008 07:40:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751366AbYBZMkU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Feb 2008 07:40:20 -0500
Received: from yoi5.greathalifaxhome.com ([66.180.172.116]:51890 "HELO
	vps1.tull.net" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with SMTP
	id S1751409AbYBZMkT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2008 07:40:19 -0500
X-Spam-Check-By: mail.local.tull.net
From: Nick Andrew <nick@nick-andrew.net>
Subject: [PATCH try #1] Kconfig: cleanup block/Kconfig.iosched help	descriptions
To: trivial@kernel.org
Cc: linux-kernel@vger.kernel.org, jens.axboe@oracle.com,
       nickpiggin@yahoo.com.au, akpm@linux-foundation.org
Date: Tue, 26 Feb 2008 23:39:46 +1100
Message-ID: <20080226122234.17726.93705.stgit@marcab.local.tull.net>
User-Agent: StGIT/0.14.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-SMTPD: qpsmtpd/0.26, http://develooper.com/code/qpsmtpd/
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Modify the help descriptions of block/Kconfig.iosched for clarity, accuracy and consistency.

More information is added to each of the I/O scheduler choices and they
are also reordered to improve the flow of information to the user.

IOSCHED_CFQ is the default because it distributes the bandwidth fairly.
It's also the place I decided to add the most help text, because it seems
not possible to add help text to the menu "IO Schedulers" itself.

So IOSCHED_CFQ is annotated with two things. Firstly a hint about how
to use the prioritisation at runtime, i.e. through the ionice(1) command.
Secondly, a reference to Documentation/block/switching-sched.txt to
show how to switch the scheduler for block devices at runtime, and/or
choose a new scheduler via the 'elevator=' kernel parameter.

These schedulers can be compiled as modules (except for noop-iosched)
so this is mentioned in each case. However the Kconfig won't allow a
scheduler which is built as a module to be chosen as the default
scheduler, and I noted that.

The boilerplate "If unsure, say Y" was added to IOSCHED_CFQ, IOSCHED_AS
and IOSCHED_DEADLINE.

A 1-line help description was added to each of the 4 choices under
"Default I/O scheduler". It won't explain anything, but it's friendlier
than saying nothing at all.


Signed-off-by: Nick Andrew <nick@nick-andrew.net>
---
Questions: Why can't a module be chosen as the default scheduler? The
elevator_get() function in block/elevator.c seems to support it. Is
it that the kernel won't be able to load the module off disk before
it has a scheduler loaded?

Also for people who want to compile only the bare minimum in a kernel
it would seem reasonable to allow IOSCHED_NOOP to be turned off. Is
the lack of a setting here another safety feature? elevator.c certainly
assumes that 'noop' is available:

        if (!e) {
                e = elevator_get(CONFIG_DEFAULT_IOSCHED);
                if (!e) {
                        printk(KERN_ERR
                                "Default I/O scheduler not found. " \
                                "Using noop.\n");
                        e = elevator_get("noop");
                }
        }

(note lack of a further test for !e)

Finally my understanding is that USB storage devices, for example,
have constant access time, and so use of an elevator algorithm won't
benefit anything. For these devices why can't the kernel choose "noop"
instead of the default and save the time/space used by the default?


 block/Kconfig.iosched |   74 ++++++++++++++++++++++++++++++++++++++-----------
 1 files changed, 58 insertions(+), 16 deletions(-)


diff --git a/block/Kconfig.iosched b/block/Kconfig.iosched
index 7e803fc..96a01b3 100644
--- a/block/Kconfig.iosched
+++ b/block/Kconfig.iosched
@@ -2,15 +2,28 @@ if BLOCK
 
 menu "IO Schedulers"
 
-config IOSCHED_NOOP
-	bool
+config IOSCHED_CFQ
+	tristate "CFQ I/O scheduler"
 	default y
 	---help---
-	  The no-op I/O scheduler is a minimal scheduler that does basic merging
-	  and sorting. Its main uses include non-disk based block devices like
-	  memory devices, and specialised software or hardware environments
-	  that do their own scheduling and require only minimal assistance from
-	  the kernel.
+	  The CFQ I/O scheduler tries to distribute bandwidth equally
+	  among all processes in the system. It should provide a fair
+	  working environment, suitable for desktop systems.
+
+	  This is the default I/O scheduler.
+
+	  The CFQ I/O scheduler supports prioritisation for individual
+	  processes; see ionice(1) for details.
+
+	  See <file:Documentation/block/switching-sched.txt> for details
+	  on how to choose a default I/O scheduler at boot time and also
+	  on a per-device basis at run time.
+
+	  To compile this scheduler as a module, choose M here; the module
+	  will be called cfq-iosched. A scheduler built as a module cannot
+	  be chosen as default.
+
+	  If unsure, say Y.
 
 config IOSCHED_AS
 	tristate "Anticipatory I/O scheduler"
@@ -21,6 +34,15 @@ config IOSCHED_AS
 	  deadline I/O scheduler, it can also be slower in some cases
 	  especially some database loads.
 
+	  See <file:Documentation/block/as-iosched.txt> for detailed
+	  information on this scheduler.
+
+	  To compile this scheduler as a module, choose M here; the module
+	  will be called as-iosched. A scheduler built as a module cannot
+	  be chosen as default.
+
+	  If unsure, say Y.
+
 config IOSCHED_DEADLINE
 	tristate "Deadline I/O scheduler"
 	default y
@@ -31,14 +53,26 @@ config IOSCHED_DEADLINE
 	  a disk at any one time, its behaviour is almost identical to the
 	  anticipatory I/O scheduler and so is a good choice.
 
-config IOSCHED_CFQ
-	tristate "CFQ I/O scheduler"
+	  See <file:Documentation/block/deadline-iosched.txt> for detailed
+	  information on this scheduler.
+
+	  To compile this scheduler as a module, choose M here; the module
+	  will be called deadline-iosched. A scheduler built as a module cannot
+	  be chosen as default.
+
+	  If unsure, say Y.
+
+config IOSCHED_NOOP
+	bool
 	default y
 	---help---
-	  The CFQ I/O scheduler tries to distribute bandwidth equally
-	  among all processes in the system. It should provide a fair
-	  working environment, suitable for desktop systems.
-	  This is the default I/O scheduler.
+	  The no-op I/O scheduler is a minimal scheduler that does basic merging
+	  and sorting. Its main uses include non-disk based block devices like
+	  memory devices, and specialised software or hardware environments
+	  that do their own scheduling and require only minimal assistance from
+	  the kernel.
+
+	  If unsure, say Y.
 
 choice
 	prompt "Default I/O scheduler"
@@ -47,17 +81,25 @@ choice
 	  Select the I/O scheduler which will be used by default for all
 	  block devices.
 
+	config DEFAULT_CFQ
+		bool "CFQ" if IOSCHED_CFQ=y
+		help
+		  Choose the CFQ I/O scheduler as default.
+
 	config DEFAULT_AS
 		bool "Anticipatory" if IOSCHED_AS=y
+		help
+		  Choose the Anticipatory I/O scheduler as default.
 
 	config DEFAULT_DEADLINE
 		bool "Deadline" if IOSCHED_DEADLINE=y
-
-	config DEFAULT_CFQ
-		bool "CFQ" if IOSCHED_CFQ=y
+		help
+		  Choose the Deadline I/O scheduler as default.
 
 	config DEFAULT_NOOP
 		bool "No-op"
+		help
+		  Choose the No-op I/O scheduler as default.
 
 endchoice
 

