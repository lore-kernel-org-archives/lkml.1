Return-Path: <linux-kernel-owner+w=401wt.eu-S1754676AbZKLWKc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754676AbZKLWKc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Nov 2009 17:10:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754389AbZKLWKa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Nov 2009 17:10:30 -0500
Received: from mail-pz0-f171.google.com ([209.85.222.171]:61978 "EHLO
	mail-pz0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754669AbZKLWK3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Nov 2009 17:10:29 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=dFENMKIDf0dakeg1VsFMhlLkkTPoWlH2ruLsXLN5v1yTGL48LbiZZrjCJHMHtec8MK
         Idl48FyM26qeBuzkYgjQXDrd9HPbap/KNC/1DffjY2Bg1jaVwK7DZ+eGXRQMhYbLNEPB
         4i3LoiXdmfYN7JFAkGPc8TdAj1qGjb9Y8l2hQ=
MIME-Version: 1.0
In-Reply-To: <20091112171942.423844000@alcatraz.americas.sgi.com>
References: <20091112171934.584037000@alcatraz.americas.sgi.com>
	 <20091112171942.423844000@alcatraz.americas.sgi.com>
Date: Thu, 12 Nov 2009 14:10:35 -0800
Message-ID: <86802c440911121410v30c5b00ewdd9ada71096b4e65@mail.gmail.com>
Subject: Re: [PATCH 1/7] x86: Limit the number of processor bootup messages
From: Yinghai Lu <yhlu.kernel@gmail.com>
To: Mike Travis <travis@sgi.com>
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Heiko Carstens <heiko.carstens@de.ibm.com>,
       Roland Dreier <rdreier@cisco.com>, Randy Dunlap <rdunlap@xenotime.net>,
       Tejun Heo <tj@kernel.org>, Andi Kleen <andi@firstfloor.org>,
       Greg Kroah-Hartman <gregkh@suse.de>, "H. Peter Anvin" <hpa@zytor.com>,
       David Rientjes <rientjes@google.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>,
       Jack Steiner <steiner@sgi.com>,
       Frederic Weisbecker <fweisbec@gmail.com>, x86@kernel.org,
       linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 12, 2009 at 9:19 AM, Mike Travis <travis@sgi.com> wrote:
> With a large number of processors in a system there is an excessive amount
> of messages sent to the system console.  It's estimated that with 4096
> processors in a system, and the console baudrate set to 56K, the startup
> messages will take about 84 minutes to clear the serial port.
>
> This set of patches limits the number of repetitious messages which contain
> no additional information.  Much of this information is obtainable from the
> /proc and /sysfs.   Most of the messages are also sent to the kernel log
> buffer as KERN_DEBUG messages so it can be used to examine more closely any
> details specific to a processor.
>
> The list of message transformations....
>
> For system_state == SYSTEM_BOOTING:
>
> [   18.669304] Booting Node   0, Processors  1 2 3 4 5 6 7 Ok.
> [   19.321065] Booting Node   1, Processors  8 9 10 11 12 13 14 15 Ok.
> [   20.065325] Booting Node   2, Processors  16 17 18 19 20 21 22 23 Ok.
> ..
> [  117.153053] Booting Node  63, Processors  1016 1017 1018 1019 1020 1021 1022 1023 Ok.
> [  117.952235] Brought up 1024 CPUs
>
> Timing shows that with NO bootup messages, it takes only slightly less time
> so printing adds very little overhead:
>
> [   18.670219] Booting all processors
> [  117.180248] Brought up 1024 CPUs
>
> For Processor Information printout, the specifics of CPU0 are printed and
> then at the end of the bootup sequence, a summary is printed:
>
> [  117.957682] Processor Information for CPUS: 0-191,208-223,256-271,...
> [  117.968034] Genuine Intel(R) CPU             0000 @ 2.13GHz stepping 04
> [  117.977406] BogoMIPS: MIN 3989.01 (7978031) AVG 4266.62 (8533249) MAX 4537.51 (9075028)
> [  117.984496] Processor Information for CPUS: 192-207,240-255,272-287,...
> [  117.996032] Genuine Intel(R) CPU             0000 @ 2.13GHz stepping 03
> [  118.001404] BogoMIPS: MIN 4021.49 (8042995) AVG 4265.91 (8531833) MAX 4479.79 (8959584)
> [  118.012373] Processor Information for CPUS: 224-239,736-751
> [  118.020032] Genuine Intel(R) CPU             0000 @ 1.87GHz stepping 03
> [  118.028033] BogoMIPS: MIN 3733.92 (7467855) AVG 3746.96 (7493933) MAX 3939.52 (7879056)
> [  118.036360] Processor Information for CPUS: 320-335,384-415,432-447,...
> [  118.044032] Intel(R) Xeon(R) CPU           X7560  @ 2.27GHz stepping 05
> [  118.053404] BogoMIPS: MIN 4244.65 (8489318) AVG 4532.45 (9064917) MAX 4666.80 (9333604)
> [  118.060644] Total of 1024 processors activated (4386353.46 BogoMIPS).
>
>
> The following lines have been removed:
>
>        CPU: Physical Processor ID:
>        CPU: Processor Core ID:
>        CPU %d/0x%x -> Node %d

why?
