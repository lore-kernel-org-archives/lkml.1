Return-Path: <linux-kernel-owner+w=401wt.eu-S1764905AbZDHNq1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764905AbZDHNq1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Apr 2009 09:46:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759455AbZDHNqO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Apr 2009 09:46:14 -0400
Received: from mail-ew0-f165.google.com ([209.85.219.165]:45575 "EHLO
	mail-ew0-f165.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759274AbZDHNqN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Apr 2009 09:46:13 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=rKtCA/F5gX8OVRnbUCezxGa7BmdnQXDxrxGaNE/xBAyVP5ulxQaVOQYKjPylLpiEvR
         TKeycLQvF+/KlxobJzx4Ilhd0Z28QmiNLDQojYN4+++TIWRvrdUfLi1BekMBctqAGbGO
         keKZ0Xegi0qeobSf0wjVfc6cwDA4YvK+JITHY=
MIME-Version: 1.0
In-Reply-To: <200904081631.09150.rusty@rustcorp.com.au>
References: <49DC2DF5.3010603@lwfinger.net> <49DC31EA.8050208@linux.intel.com>
	 <200904081631.09150.rusty@rustcorp.com.au>
Date: Wed, 8 Apr 2009 15:46:08 +0200
Message-ID: <2d0a357f0904080646l4082c803w843822c22ba0c1c0@mail.gmail.com>
Subject: Re: Regression in 2.6.30-rc1 since commit acae0515 - wireless broken
From: Sedat Dilek <sedat.dilek@googlemail.com>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: Arjan van de Ven <arjan@linux.intel.com>,
       Larry Finger <Larry.Finger@lwfinger.net>,
       LKML <linux-kernel@vger.kernel.org>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

finally, I was able to have a running 2.6.30-rc1 Linux kernel with my
iwl3945 WLAN-hardware.
Yes, iwl3945 is also affected/broken.
The below patch by Rusty is *not* fixing the problem in my case.
As Larry [1] mentionned reverting commit
acae05156551fd7528fbb616271e672789388e3c "module: create a
request_module_nowait()" worked for me, too.

>From dmesg output [iwl3945 error]:
[...]
iwl3945: Intel(R) PRO/Wireless 3945ABG/BG Network Connection driver
for Linux, 1.2.26kds
iwl3945: Copyright(c) 2003-2009 Intel Corporation
iwl3945 0000:10:00.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
iwl3945 0000:10:00.0: setting latency timer to 64
iwl3945 0000:10:00.0: Tunable channels: 13 802.11bg, 23 802.11a channels
iwl3945 0000:10:00.0: Detected Intel Wireless WiFi Link 3945ABG
iwl3945 0000:10:00.0: irq 29 for MSI/MSI-X
phy0: Selected rate control algorithm 'iwl-3945-rs'
iwl3945 0000:10:00.0: Failed to register hw (error -2)
iwl3945 0000:10:00.0: PCI INT A disabled
iwl3945: probe of 0000:10:00.0 failed with error -2
[...]

While trying to unload iwl3945-module...

$ ps axu | grep modprobe
root      2143  0.0  0.0   1836   556 ?        D<   11:27   0:00
/sbin/modprobe -b
pci:v0000104Cd00008039sv0000103Csd000030ACbc06sc07i00
root      2149  0.0  0.0   1812   532 ?        D<   11:27   0:00
/sbin/modprobe -b
pci:v0000104Cd0000803Bsv0000103Csd000030ACbc01sc80i00
root      7186  0.0  0.0   1804   544 ?        DN   11:38   0:00
modprobe -r -v iwl3945

I could *not* kill the modprobe process and my system hang while halting.

In addition, I had troubles with the ACPI-battery [2] and max3100
serial-driver [3] and applied the according patches.
Last but not least, I disabled CONFIG_VIDEO_GO7007 (is broken).
For more Details see below investigations section.

With the 3 patches a "normal" booting was possible (w/o ACPI-battery
patch the system hangs for a while) and WIFI works, again.
The only thing I was wondering is the reduced signal-quality from
75/80 down to 50/60 % (location of the notebook didn't change).

Hope these informations help.

Kind Regards,
Sedat

[1] http://marc.info/?l=linux-wireless&m=123916648402847&w=2
[2] http://marc.info/?l=linux-acpi&m=123918789630534&w=2
[3] http://patchwork.kernel.org/patch/17034/

------ BEGIN INVESTIGATIONS -----

>From the same dmesg output [ACPI-battery]:
[...]
Call Trace:
 [<c01500f6>] ? async_thread+0xf4/0x1f6
 [<c0130de0>] ? default_wake_function+0x0/0x30
 [<c0150002>] ? async_thread+0x0/0x1f6
 [<c014956c>] ? kthread+0x4a/0x82
 [<c0149522>] ? kthread+0x0/0x82
 [<c01047a7>] ? kernel_thread_helper+0x7/0x10
Code: 00 00 00 00 00 00 00 00 01 00 03 00 01 00 00 00 00 00 00 00 00
00 00 00 18 1b 00 00 00 00 00 00 34 00 00 00 00 00 28 00 19 00 16 <00>
04 00 00 00 14 00 00 00 03 00 00 00 47 4e 55 00 3a 35 91 0c
EIP: [<f807e033>] 0xf807e033 SS:ESP 0068:f650ff98
CR2: 0000000000000000
---[ end trace 426c85e9e66d48c6 ]---
[...]

>From the build-log [max3100 serial-driver]:
[...]
make[4]: *** No rule to make target `drivers/serial/max3100.c', needed
by `drivers/serial/max3100.o'.  Stop.
[...]

>From the build-log [go7007-driver] :
[...]
drivers/staging/go7007/go7007-driver.c:284: error: 'TUNER_SET_TYPE'
undeclared (first use in this function)
drivers/staging/go7007/go7007-driver.c:284: error: (Each undeclared
identifier is reported only once
drivers/staging/go7007/go7007-driver.c:284: error: for each function
it appears in.)
make[5]: *** [drivers/staging/go7007/go7007-driver.o] Error 1
make[4]: *** [drivers/staging/go7007] Error 2
make[3]: *** [drivers/staging] Error 2
[...]

------ END INVESTIGATIONS -----

On Wed, Apr 8, 2009 at 9:01 AM, Rusty Russell <rusty@rustcorp.com.au> wrote:
> On Wednesday 08 April 2009 14:41:06 Arjan van de Ven wrote:
>> Larry Finger wrote:
>> > The most recent pulls of the Linux-2.6 git tree has broken wireless. The problem
>> > was bisected with commit acae05156551fd7528fbb616271e672789388e3c, entitled
>> > "module: create a request_module_nowait()", indicated as the faulty change. This
>> > is seen with driver b43 on my system, and 2 reports for driver iwlagn:
>> > http://marc.info/?l=linux-wireless&m=123916157630571&w=2 and
>> > http://marc.info/?l=linux-wireless&m=123913015021457&w=2.
>> >
>> > For b43, the logged error messages are:
>>
>> rusty... I still suspect your "int to bool" conversion stuff ;-)
>
> One way to find out.  Here's the reversion:
>
> diff --git a/include/linux/kmod.h b/include/linux/kmod.h
> --- a/include/linux/kmod.h
> +++ b/include/linux/kmod.h
> @@ -29,12 +29,10 @@
>  #ifdef CONFIG_MODULES
>  /* modprobe exit status on success, -ve on error.  Return value
>  * usually useless though. */
> -extern int __request_module(bool wait, const char *name, ...) \
> -       __attribute__((format(printf, 2, 3)));
> -#define request_module(mod...) __request_module(true, mod)
> -#define request_module_nowait(mod...) __request_module(false, mod)
> -#define try_then_request_module(x, mod...) \
> -       ((x) ?: (__request_module(false, mod), (x)))
> +extern int __request_module(int wait, const char *name, ...) __attribute__ ((format (printf, 2, 3)));
> +#define request_module(mod...) __request_module(1, mod)
> +#define request_module_nowait(mod...) __request_module(0, mod)
> +#define try_then_request_module(x, mod...) ((x) ?: (__request_module(0, mod), (x)))
>  #else
>  static inline int request_module(const char *name, ...) { return -ENOSYS; }
>  static inline int request_module_nowait(const char *name, ...) { return -ENOSYS; }
> diff --git a/kernel/kmod.c b/kernel/kmod.c
> --- a/kernel/kmod.c
> +++ b/kernel/kmod.c
> @@ -64,7 +64,8 @@ char modprobe_path[KMOD_PATH_LEN] = "/sb
>  * If module auto-loading support is disabled then this function
>  * becomes a no-operation.
>  */
> -int __request_module(bool wait, const char *fmt, ...)
> +
> +int __request_module(int wait, const char *fmt, ...)
>  {
>        va_list args;
>        char module_name[MODULE_NAME_LEN];
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
