Return-Path: <linux-kernel-owner+w=401wt.eu-S1755271AbYISX4E@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755271AbYISX4E (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Sep 2008 19:56:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752258AbYISXzy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Sep 2008 19:55:54 -0400
Received: from fg-out-1718.google.com ([72.14.220.153]:46822 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751734AbYISXzx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Sep 2008 19:55:53 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references:x-google-sender-auth;
        b=frxnUQXeXrRPnlYVFtC3DltrMzYTR5J12rsmXnd/2OVa4E9bSCJxqncTjxO/6Dw4x9
         B/oTTUQDoZke6iYIF7StR7mrSMlW+o51Bw0/wdBQHFUBGT+fbCpYS8BaLlkA5pdnn02c
         bz43fSXpHRVgD+3KhVdlby/yB1aNqRYKC2da8=
Message-ID: <70318cbf0809191655m89e4b4fo68c3693487afed98@mail.gmail.com>
Date: Fri, 19 Sep 2008 16:55:51 -0700
From: "Chris Li" <lkml@chrisli.org>
To: "Takashi Iwai" <tiwai@suse.de>
Subject: Re: diet-kconfig: a script to trim unneeded kconfigs
Cc: "Giacomo A. Catenazzi" <cate@cateee.net>,
       "Mauro Carvalho Chehab" <mchehab@infradead.org>,
       "Steven Rostedt" <rostedt@goodmis.org>, linux-kernel@vger.kernel.org
In-Reply-To: <s5hy71oyviu.wl%tiwai@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <s5hbpyny7bl.wl%tiwai@suse.de>
	 <20080918122541.2c3c7b39@areia.chehab.org>
	 <48D27734.3040600@cateee.net>
	 <alpine.LFD.1.10.0809181154020.12224@bombadil.infradead.org>
	 <48D36D02.4090003@cateee.net> <s5hy71oyviu.wl%tiwai@suse.de>
X-Google-Sender-Auth: a1a26755c0846566
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 19, 2008 at 9:01 AM, Takashi Iwai <tiwai@suse.de> wrote:
> Yes.  Your stuff would be actually helpful for people who want
> a really slim kernel config.

Incidentally, I wrote such a script as well. In 64 lines of python code.
I attach the script in question in the mail. I use a approach very
similar to yours. But I work around some of the nasty part.

It needs to start with kernel config has most of the modules enabled.
Most of the kernel config from the linux distribution is like that.
Then it try to parse the Kbuild looking for what kernel config produce
what module. It is not a 1 to 1 mapping.

Once  we have the mapping. It open /proc/modules to go over every
module. Remove the config which can produce those module from the
mapping.

Now we have a blacklist of config produce modules but not the one we want.

Then  the last stage is just open a config file and filter out the config
option on the blacklist. Write the result to a new config file.

I avoid arch/ and firmware/ because it is nasty. I figure module in
arch/ is small enough I don't mind building it. And the firmware directory,
if I don't build the module loads it. Those firmware will automatically skipped
any way.

The little tricky part is some thing like this:
========================
ifeq ($(CONFIG_BLK_DEV_CMD640), m)
        obj-m += cmd640.o
endif
========================
Internally it get convert it into:
"obj-$(CONFIG_BLK_DEV_CMD640) += cmd640.o"

For easier parsing.
It is pretty fast as well. Less then a second if the file cache is
hot.

$ time minmod.py .config
reading Kbuild Makefile 593 files
acpi_cpufreq : Uknown module, may be firmware?
dcdbas : Uknown module, may be firmware?
1560 module option disabled
Writing new config to: .config.min

real	0m0.470s
user	0m0.303s
sys	0m0.075s
$

Chris
