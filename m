Return-Path: <linux-kernel-owner+w=401wt.eu-S1752195AbYKQPCg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752195AbYKQPCg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2008 10:02:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751502AbYKQPCX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Nov 2008 10:02:23 -0500
Received: from fg-out-1718.google.com ([72.14.220.153]:37173 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752768AbYKQPCV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2008 10:02:21 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=message-id:date:from:reply-to:to:subject:cc:in-reply-to
         :mime-version:content-type:content-transfer-encoding
         :content-disposition:references;
        b=rBLdFk7TelnQRHnH8nZ87JpiNoUtElyHvMVnEb2BhMUeVRRlq6ar4ystznLz3cagfG
         qk8fS2IcQF6/ieTT968XxYhu/47P39IpeVprEgdIQryfQ1MFyoGVvTcUyQKFUC+hzqZK
         1sjo10xEnhZUPcHToEdWOsF/mO73o6BpVRJjg=
Message-ID: <7c86c4470811170702y127c9249m9b86b65a38a3e05c@mail.gmail.com>
Date: Mon, 17 Nov 2008 16:02:19 +0100
From: "stephane eranian" <eranian@googlemail.com>
Reply-To: eranian@gmail.com
To: "Andi Kleen" <andi@firstfloor.org>
Subject: Re: Oprofile : need to adjust PC by 16 bytes
Cc: "Eric Dumazet" <dada1@cosmosbay.com>, "Mikael Pettersson" <mikpe@it.uu.se>,
       "Robert Richter" <robert.richter@amd.com>, oprofile-list@lists.sf.net,
       "Ingo Molnar" <mingo@elte.hu>, "Jiri Kosina" <jkosina@suse.cz>,
       "Jiri Benc" <jbenc@suse.cz>, "Vilem Marsik" <vmarsik@suse.cz>,
       "Pekka Enberg" <penberg@cs.helsinki.fi>, linux-kernel@vger.kernel.org
In-Reply-To: <20081115183627.GL3810@one.firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
References: <alpine.LNX.1.10.0811132147030.19853@jikos.suse.cz>
	 <alpine.LNX.1.10.0811132226140.19853@jikos.suse.cz>
	 <20081113213744.GA8429@elte.hu> <491CA0DC.8070405@cosmosbay.com>
	 <491D987F.1000301@cosmosbay.com>
	 <18717.44751.459961.277998@harpo.it.uu.se>
	 <491DB391.2040701@cosmosbay.com>
	 <20081114175056.GK3810@one.firstfloor.org>
	 <491EF942.1090709@cosmosbay.com>
	 <20081115183627.GL3810@one.firstfloor.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by alpha id mAHF37dq018674

Hello,
I have not seen the beginning of that discussion so my comments may beslightly off.It seems Eric has problems with accuracy of instruction addresses whensampling with the PMU.
This is an inherent limitation of the PMU. It can be mitigated but notcompletely eliminated. The coreissue is that it takes several cycles between the moment a counteroverflows and posting of the PMUinterrupt. During that time, the CPU keeps on executing instructions.The interrupt IP you get, reflectsthe place you were when it triggered. That can be far away from whereit was posted and where thecounter actually overflowed. Of course, if you are stalled thatdistance is usually 0 or off by a smallnumber of instructions. But it can be very large when overflow happensduring a kernel critical sectionwhere interrupts are off. There is nothing SW can do about all of this.
Andi mentioned PEBS. I don't know if you are familiar with what itdoes. Let me summarize. This isa hardware/microcode feature which implements a hardware-managedbuffer where samples arestored. The OS points the CPU to a memory region where PMU samples arestored. No PMUinterrupt is generated until the buffer becomes full. That partaddresses some of the overheadassociated with interrupt-based sampling. Unfortunately, PEBS  doesnot point to the instruction wherethe counter overflowed, it will still be a few instructions off. Butthis time, you get the machine state at thelast retired instruction. Furthermore, PEBS can record samples whilein kernel critical sections. A limitationof PEBS is that it does not work with all the PMU events. Only ahandful are available.
As for perfmon, if you pull from the perfmon2 GIT tree, this shouldwork. Don't know what happen inyou case.
Perfmon and the pfmon can do simple counting or also collect profiles.
$ pfmon date
Counts cycles at the user level only for the process date
$ pfmon --system-wide -t10
Counts elapsed cycles at user level for all CPU for 10s. Results are per-cpu
$ pfmon --long-smpl-periods=240000 date
Collect a flat profile of process date. Period is 240,000 elapsed user cycle
$ pfmon --system-wide --long-smpl-periods=240000 -t 10
Collect a flat profile on each online CPU during 10s. Period is240,000 user elapsed cycles. Results are per-cpu
You have a lot  more examples on the perfmon web site, Following thedocumentation and pfmon users' guide.
Perfmon/pfmon can use PEBS on Intel Core processors. First step is toinsert the kernel module for it:   # modprobe perfmon_pebs_core_smpl
Then use pfmon, we use instruction_retired because elapsed cycles doesnot support PEBS:
   $ pfmon --smpl-module=pebs -einstructions_retired--long-smpl-periods=120000 date
Hope this helps.

On Sat, Nov 15, 2008 at 7:36 PM, Andi Kleen <andi@firstfloor.org> wrote:> On Sat, Nov 15, 2008 at 05:30:58PM +0100, Eric Dumazet wrote:>> Andi Kleen a Ã©crit :>> >>>And no, blindly subtracting 16 from IP is not a fix.>> >>Who mentioned a fix ? I am only giving more fuel to Intel guys so they>> >>hopefully can give us a working oprofile.>> >>> >You would need to implement PEBS support to avoid that problem. But it's a>> >big>> >task. perfmon2 implements it already.>> >>>>> Thanks for the information.>>>> Hum, so I grabbed perfmon2 git tree, installed various tools...>>>> I am quite new to pfmon and tried :>>>> # pfmon --system-wide>> sizeof=64 44>> <press ENTER to stop session>>>>> Then started "tbench 8", and got a kernel panic after 6 seconds.>>>>>> I was using oprofile like this>>>> opcontrol --vmlinux=/path/vmlinux --start>> // doing some benchmarking...>> opreport -l vmlinux | head -n 40>>>>>> What would be a working equivalent for perfmon2 based tools ?>> Probably getting a perfmon tree that works. I guess Stephane> can help (cc'ed).  Or just deal with imprecise events for now.>> -Andi> --> ak@linux.intel.com>ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
