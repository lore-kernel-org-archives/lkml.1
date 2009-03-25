Return-Path: <linux-kernel-owner+w=401wt.eu-S1756312AbZCYVho@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756312AbZCYVho (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Mar 2009 17:37:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756139AbZCYVh1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Mar 2009 17:37:27 -0400
Received: from pipapo.org ([217.140.77.75]:47421 "EHLO mail.pipapo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756064AbZCYVh0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Mar 2009 17:37:26 -0400
X-Greylist: delayed 563 seconds by postgrey-1.27 at vger.kernel.org; Wed, 25 Mar 2009 17:37:25 EDT
Message-ID: <49CAA1DF.8060109@pipapo.org>
Date: Wed, 25 Mar 2009 22:27:59 +0100
From: Christian Thaeter <ct@pipapo.org>
User-Agent: Mozilla-Thunderbird 2.0.0.19 (X11/20090103)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: Pavel Machek <pavel@ucw.cz>, eric.piel@tremplin-utc.net
Subject: [PATCH] hpfall.c improvements, thoughts
References: <49C8F338.7030901@pipapo.org> <20090324211555.GA24172@elf.ucw.cz>
In-Reply-To: <20090324211555.GA24172@elf.ucw.cz>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some conversation I had with Pavel,

imo the example code should be at least barely useable as in not causing
harm like I sketched in (1.). Maybe someone else picks that up and
improves it later on. Patch at the end, quite sketchy and imature as it
doesn't check for errors, but certainly better than before.


	Christian


Pavel Machek wrote:
> Hi!
> 
>> I just hacked and installed the hpfall utility a little bit. By that I
>> thought I should share some ideas with you. (made no patch since this is
>> trivial, but important)
>>
>> 1. hpfall *MUST* mlockall(MCL_CURRENT|MCL_FUTURE); itself!
>> Since the Program sits and waits most of the time it becomes very likely
>> swapped out. If it gets woken up when the laptop drops from the table
>> while it is swapped out it actually triggers harddrive activity!
>>
>> 2. daemon(0, 0);  ... Quick and dirty way to daemonize it
>>
>> 3. Realtime priority:
>>  param.sched_priority = sched_get_priority_max(SCHED_FIFO);
>>  sched_setscheduler(0, SCHED_FIFO, &param);
>> Should give a chance that it has less latency when woken up.
> 
> Good ideas. I ommited them, thinking that someone else will do it. Can
> you submit a patch? (akpm, cc: lk, Eric Piel) I no longer have the
> hardware, and would prefer not to patch code I can't test.
> 
>> .. another thing is that I still use the old IDE driver, I just changed
>> sda to hda, maybe a bandaid is to use argv[1] for defining the drive
>> (well I understand that it is very basic example code, so maybe someday
>> someone adds a better option parser)
> 
> Option parser would indeed be nice.
> 								Pavel
>


Signed-off-by: Christian Thaeter <ct@pipapo.org>
---

diff --git a/Documentation/hwmon/hpfall.c b/Documentation/hwmon/hpfall.c
index bbea1cc..f3cde67 100644
--- a/Documentation/hwmon/hpfall.c
+++ b/Documentation/hwmon/hpfall.c
@@ -16,6 +16,8 @@
 #include <stdint.h>
 #include <errno.h>
 #include <signal.h>
+#include <sys/mman.h>
+#include <sched.h>

 void write_int(char *path, int i)
 {
@@ -63,6 +65,7 @@ void ignore_me(void)
 int main(int argc, char* argv[])
 {
        int fd, ret;
+       struct sched_param param;

        fd = open("/dev/freefall", O_RDONLY);
        if (fd < 0) {
@@ -70,7 +73,12 @@ int main(int argc, char* argv[])
                return EXIT_FAILURE;
        }

-	signal(SIGALRM, ignore_me);
+       daemon(0,0);
+       param.sched_priority = sched_get_priority_max(SCHED_FIFO);
+       sched_setscheduler(0, SCHED_FIFO, &param);
+       mlockall(MCL_CURRENT|MCL_FUTURE);
+
+       signal(SIGALRM, ignore_me);

        for (;;) {
 	       unsigned char count;

