Return-Path: <linux-kernel-owner+w=401wt.eu-S1754021AbZBUGUN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754021AbZBUGUN (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Feb 2009 01:20:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752029AbZBUGUA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Feb 2009 01:20:00 -0500
Received: from acsinet11.oracle.com ([141.146.126.233]:61628 "EHLO
	acsinet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751969AbZBUGT7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Feb 2009 01:19:59 -0500
Message-ID: <499F9D25.8010300@oracle.com>
Date: Fri, 20 Feb 2009 22:20:21 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
Organization: Oracle Linux Engineering
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Steven Rostedt <rostedt@goodmis.org>, LKML <linux-kernel@vger.kernel.org>,
       linux-kbuild@vger.kernel.org, Randy Dunlap <randy.dunlap@oracle.com>,
       Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       zippel@linux-m68k.org
Subject: Re: [PATCH][RFC] check for select dependency errors on config load
References: <499edf47.1818d00a.060b.2b8d@mx.google.com>	<499EE162.4050008@oracle.com>	<alpine.DEB.2.00.0902210008580.30069@gandalf.stny.rr.com> <20090220220810.6f4360f0.akpm@linux-foundation.org>
In-Reply-To: <20090220220810.6f4360f0.akpm@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt701.oracle.com [141.146.40.71]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A0B020A.499F9CED.009E:SCFSTAT928724,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
> On Sat, 21 Feb 2009 00:24:05 -0500 (EST) Steven Rostedt <rostedt@goodmis.org> wrote:
> 
>> There's been a few problems with SELECT and dependencies lately.
>> I've been burnt by it a few times myself. So I look at the kconfig
>> code and added this patch. It can use a bit more work but it does what
>> I want.
>>
>> When the config is loaded, it checks all the symbols that are
>> selected by an active config and makes sure the visible dependencies are 
>> also activated. This should probably be moved to the writing of the 
>> config instead, but since I just wanted to see if my current config was 
>> OK, I did it on load. This is an RFC patch anyway, so fixes/comments are 
>> definitely welcome.
>>
>> Here's what I get with the attached config running on 2.6.29-rc5.
>>
>> $ make menuconfig
>> scripts/kconfig/mconf arch/x86/Kconfig
>> .config:2561:warning: MICROCODE selects FW_LOADER which fails its dependencies!
>> .config:2561:warning: MICROCODE_INTEL selects FW_LOADER which fails its dependencies!
>> .config:2561:warning: PCMCIA_LOAD_CIS selects FW_LOADER which fails its dependencies!
>> .config:2561:warning: SCSI_SAS_LIBSAS selects SCSI_SAS_ATTRS which fails its dependencies!
>> .config:2561:warning: SCSI_AIC94XX selects FW_LOADER which fails its dependencies!
>> .config:2561:warning: KEYBOARD_ATKBD selects SERIO which fails its dependencies!
>> .config:2561:warning: KEYBOARD_ATKBD selects SERIO_LIBPS2 which fails its dependencies!
>> .config:2561:warning: KEYBOARD_ATKBD selects SERIO_I8042 which fails its dependencies!
>> .config:2561:warning: MOUSE_PS2 selects SERIO which fails its dependencies!
>> .config:2561:warning: MOUSE_PS2 selects SERIO_LIBPS2 which fails its dependencies!
>> .config:2561:warning: MOUSE_PS2 selects SERIO_I8042 which fails its dependencies!
>> .config:2561:warning: VT selects INPUT which fails its dependencies!
>> .config:2561:warning: DRM selects I2C_ALGOBIT which fails its dependencies!
>> .config:2561:warning: SND_EMU10K1 selects FW_LOADER which fails its dependencies!
>>
>> <exit out>
>>
> 
> OK, this is fairly easy to use.
> 
> You get
> 
> .config:1181:warning: PCMCIA_LOAD_CIS selects FW_LOADER which fails its dependencies!
> 
> So you then go into `make menuconfig' and type /^fw_loader$ to display
> FW_LOADER's dependencies.
> 
> 	Depends on: HOTPLUG && EMBEDDED
> 
> then do `egrep "HOTPLUG|EMBEDDED" .config'
> 
> And we discover weird things.  Why does FW_LOADER depend on EMBEDDED?
> 
> And why the heck does INPUT depend on EMBEDDED?!??!
> 
> And what's up with CONFIG_SERIO?
> 
> 	Depends on: !S390 && (EMBEDDED || !X86)
> 
> hm.

EMBEDDED is misnamed.  It means "those who think that they know enough
to use all of the power of kconfig."
Some people spell that EXPERT etc.
Or it means "let me shoot myself in the foot."

So HOTPLUG, INPUT, FW_LOADER, etc. should not be modified by Aunt Tillie,
but you and I can play with them.


for SERIO:

config SERIO
	tristate "Serial I/O support" if EMBEDDED || !X86
	default y

Experts can modify it.  !X86 can modify it.
It's usually needed on X86 for keyboard controllers etc.,
but if one sets EMBEDDED, you can muck up your config and not be
able to use the keyboard.

I don't know where the !S390 comes from, but it's not surprising.

-- 
~Randy
