Return-Path: <linux-kernel-owner+w=401wt.eu-S1762001AbZLLLZm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762001AbZLLLZm (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Dec 2009 06:25:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761529AbZLLLZj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 Dec 2009 06:25:39 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:47055 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761525AbZLLLZj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Dec 2009 06:25:39 -0500
Date: Sat, 12 Dec 2009 12:25:36 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Arve Hj?nnev?g <arve@android.com>
Cc: Brian Swetland <swetland@google.com>,
       Daniel Walker <dwalker@codeaurora.org>,
       kernel list <linux-kernel@vger.kernel.org>,
       linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
       Iliyan Malchev <malchev@google.com>, linux-kernel@codeaurora.org
Subject: Re: tree with htc dream support
Message-ID: <20091212112536.GA2302@elf.ucw.cz>
References: <20091205221100.GA32522@elf.ucw.cz>
 <1260054737.23633.35.camel@desktop>
 <a55d774e0912051638u7858878cg7cf62905c3c005c1@mail.gmail.com>
 <d6200be20912112142r7bdf8f18o31edd4457aa64998@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <d6200be20912112142r7bdf8f18o31edd4457aa64998@mail.gmail.com>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri 2009-12-11 21:42:07, Arve Hj?nnev?g wrote:
> On Sat, Dec 5, 2009 at 4:38 PM, Brian Swetland <swetland@google.com> wrote:
> > Arve's about to take our common and msm trees and rebase them over the .32,
> > which may be useful for reference -- at least as a snapshot of a fully
> > functional set of patches that android donut and eclair run on, on
> > production hardware.  We'll make that available as soon as we have something
> > that's bootable.
> >
> > Brian
> >
> >
> 
> A first pass of this is available in the android-msm-2.6.32-test1
> branch at git://android.git.kernel.org/kernel/experimental.git.

According to some docs, i2c_detach can be just removed, so...?

Then I got this:

  CC      drivers/input/misc/gpio_axis.o
  CC      drivers/input/misc/keychord.o
drivers/input/misc/keychord.c: In function 'keychord_event':
drivers/input/misc/keychord.c:129: error: 'TASK_INTERRUPTIBLE'
undeclared (first use in this
function)drivers/input/misc/keychord.c:129: error: (Each undeclared
identifier is reported only once
drivers/input/misc/keychord.c:129: error: for each function it appears
in.)
drivers/input/misc/keychord.c: In function 'keychord_read':
drivers/input/misc/keychord.c:205: error: 'TASK_INTERRUPTIBLE'
undeclared (first use in this
function)drivers/input/misc/keychord.c:205: error: implicit
declaration of function 'signal_pending'
drivers/input/misc/keychord.c:205: error: implicit declaration of
function 'schedule'
make[3]: *** [drivers/input/misc/keychord.o] Error 1
make[2]: *** [drivers/input/misc] Error 2
make[1]: *** [drivers/input] Error 2
make: *** [drivers] Error 2
12.60user 2.53system 16.93 (0m16.939s) elapsed 89.36%CPU
pavel@amd:/data/l/linux-msm-32$

I used this to fix the compilation...

Signed-off-by: Pavel Machek <pavel@ucw.cz>

diff --git a/drivers/i2c/chips/mt9t013.c b/drivers/i2c/chips/mt9t013.c
index e911ece..200a9f8 100755
--- a/drivers/i2c/chips/mt9t013.c
+++ b/drivers/i2c/chips/mt9t013.c
@@ -1298,7 +1298,6 @@ static int mt9t013_remove(struct i2c_client *client)
 	struct mt9t013_data *mt = i2c_get_clientdata(client);
 	free_irq(client->irq, mt);
 	deinit_suspend();
-	i2c_detach_client(client);
 	pclient = NULL;
 	misc_deregister(&mt9t013_device);
 	kfree(mt);
diff --git a/drivers/input/misc/keychord.c b/drivers/input/misc/keychord.c
index ea94f26..ca23905 100644
--- a/drivers/input/misc/keychord.c
+++ b/drivers/input/misc/keychord.c
@@ -23,6 +23,7 @@
 #include <linux/fs.h>
 #include <linux/miscdevice.h>
 #include <linux/keychord.h>
+#include <linux/sched.h>
 
 #define KEYCHORD_NAME		"keychord"
 #define BUFFER_SIZE			16

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
