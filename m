Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933979Ab0BZKjI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Feb 2010 05:39:08 -0500
Received: from mail-wy0-f174.google.com ([74.125.82.174]:57327 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933635Ab0BZKjB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Feb 2010 05:39:01 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=XaUbgxubGUjzcV7PP6j9JF4J/MiaqT8HFKndJL42/9AkO5Cf7DRV1LrHMGN45WfVkW
         qZchGctmKBHg8rhUR+vzm0yE5zbXnxp51BBafrbXDQD92i1gjMcumR3hG8JqxPVGXrCz
         EL/BBwerDxv7qrR9n07YfJbs9EQ1sI0Pm0mN4=
MIME-Version: 1.0
In-Reply-To: <1266761422-2921-1-git-send-email-zajec5@gmail.com>
References: <1266761422-2921-1-git-send-email-zajec5@gmail.com>
Date: Fri, 26 Feb 2010 11:38:59 +0100
Message-ID: <b170af451002260238p29c7db97nd50154bf7288ef42@mail.gmail.com>
Subject: Re: [PATCH][RFC] time: add wait_interruptible_timeout macro to sleep 
	(w. timeout) until wake_up
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       DRI <dri-devel@lists.sourceforge.net>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by alpha.home.local id o1QAdHmE028437

Forwarding to ppl I could often notice in git log time.h

---------- Wiadomość przekazana dalej ----------From: Rafał Miłecki <zajec5@gmail.com>Date: 21 lutego 2010 15:10Subject: [PATCH][RFC] time: add wait_interruptible_timeout macro tosleep (w. timeout) until wake_upTo: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,dri-devel@lists.sourceforge.netCC: Rafał Miłecki <zajec5@gmail.com>

Signed-off-by: Rafał Miłecki <zajec5@gmail.com>---We try to implement some PM in radeon KMS and we need to sync with VLBANK forreclocking engine/memory. The easiest and cleanest way seems to be sleeping intimer handler just before reclocking. Then our IRQ handler calls wake_up and wecontinue reclocking.
As you see our sleeping is condition-less, we just wait for waking up queue.
We hope this waking will happen from IRQ handler, but for less-happy case wealso use some timeout (this will probably cause some single corruption, butwe can live with it).
Following macro is soemthing that seems to work fine for us, but insteadintroducing this to radeon KMS only, I'd like to propose adding this to wholewait.h. Do you this it's something we should place there? Can someone take thispatch for me? Or maybe you find this rather useless and we should keep thismarco locally?--- include/linux/wait.h |   25 +++++++++++++++++++++++++ 1 files changed, 25 insertions(+), 0 deletions(-)
diff --git a/include/linux/wait.h b/include/linux/wait.hindex a48e16b..998475b 100644--- a/include/linux/wait.h+++ b/include/linux/wait.h@@ -332,6 +332,31 @@ do {                         \       __ret;                                                          \ })
+/**+ * wait_interruptible_timeout - sleep until a waitqueue is woken up+ * @wq: the waitqueue to wait on+ * @timeout: timeout, in jiffies+ *+ * The process is put to sleep (TASK_INTERRUPTIBLE) until the waitqueue+ * @wq is woken up. It can be done manually with wake_up or will happen+ * if timeout elapses.+ *+ * The function returns 0 if the @timeout elapsed, remaining jiffies+ * if workqueue was waken up earlier.+ */+#define wait_interruptible_timeout(wq, timeout)         \+({                                                                     \+       long __ret = timeout;                                           \+                                                                       \+       DEFINE_WAIT(__wait);                                            \+       prepare_to_wait(&wq, &__wait, TASK_INTERRUPTIBLE);              \+       if (!signal_pending(current))                                   \+               __ret = schedule_timeout(__ret);                        \+       finish_wait(&wq, &__wait);                                      \+                                                                       \+       __ret;                                                          \+})+ #define __wait_event_interruptible_exclusive(wq, condition, ret)       \ do {                                                                   \       DEFINE_WAIT(__wait);                                            \--1.6.4.2���{.n�+�������+%�����ݶ��w��{.n�+����{��G�����{ay�ʇڙ�,j��f���h��������z_�(�階�ݢj"���m������G������?����&���~��iO��z��v�^�m����������?�I�
