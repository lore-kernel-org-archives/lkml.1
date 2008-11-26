Return-Path: <linux-kernel-owner+w=401wt.eu-S1753531AbYKZTQ0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753531AbYKZTQ0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Nov 2008 14:16:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752435AbYKZTQS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Nov 2008 14:16:18 -0500
Received: from qw-out-2122.google.com ([74.125.92.26]:29667 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751449AbYKZTQR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Nov 2008 14:16:17 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=C6yqViAKQ5NMPJj2S2IgFxP5e1yvF5NgbcDuIXm/H95QfS1Z/ZdhYvEi8u8jtTbpVF
         VJfo/RsDY6Enc9dJFzaALrPXYR8B+VO7ikV4t1Yd91v8gdmpEe5tobKirrhrY5QhVfoS
         Fy3ih7bCkDclhf0MDxHsunUrNR7dcxSyMmItk=
Message-ID: <c62985530811261116n301d5a9t375e0cfb203b5cc8@mail.gmail.com>
Date: Wed, 26 Nov 2008 20:16:15 +0100
From: "=?ISO-8859-1?Q?Fr=E9d=E9ric_Weisbecker?=" <fweisbec@gmail.com>
To: "Tim Bird" <tim.bird@am.sony.com>
Subject: Re: [PATCH 4/4] tracing/function-return-tracer: Support for dynamic ftrace on function return tracer
Cc: "Steven Rostedt" <rostedt@goodmis.org>, "Ingo Molnar" <mingo@elte.hu>,
       "Linux Kernel" <linux-kernel@vger.kernel.org>
In-Reply-To: <492D940F.6090500@am.sony.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
References: <491FA94E.9090207@gmail.com>
	 <alpine.DEB.1.10.0811241707240.907@gandalf.stny.rr.com>
	 <c62985530811241421t1cd56b4el1ada0754df9a229@mail.gmail.com>
	 <492D940F.6090500@am.sony.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by alpha id mAQJGUdq021420

Hi Tim,
2008/11/26 Tim Bird <tim.bird@am.sony.com>:> ï¿½ wrote:> Very sorry I'm coming to this thread late.  I didn't notice it until> today.>> Not to question the whole approach, and sorry if this was> discussed before, but why wasn't -finstrument-functions used> to instrument the function exits.  This worked well for KFT> (See http://elinux.org/Kernel_Function_Trace).  I'm not sure if the> function prologue and epilogue modifications done by -mcount are> different than -finstrument-functions, but I thought I remember something> about Steven testing -finstrument-functions in an early version of ftrace.

Yes, we discussed it earlier but because of some reasons (kernel size,dynamic patchingcost), we used a stack of return address for each task.See the discussion about using -finstrument-functions:http://lkml.org/lkml/2008/10/30/372

> By the way, I'm really excited to see this "function_cost" stuff being> worked on.  It has proven to be extremely useful for analyzing early boot> latencies at Sony.>> Sorry again I didn't catch this and previous related threads> earlier.  I have some post-processing tools which might be useful here.

That would be welcome. Note that the output of this tracer is a bit differentfrom KFT. I'm currently working on the a C-like output:http://lkml.org/lkml/2008/11/25/389So perhaps the post-processing would have to be done in a way quitedifferent from thisused on KFT traces. I don't know.
> Also, I've found it very handy to have the capability to filter by minimum> function duration.  Is there any work to do that with the> current system.  If not, maybe I could take a look at that and see if> I can add something.
Yes there would be some modifications to do so.I guess the best thing to do that would be to use the trace_optionsfiles in whichany tracer can set some custom flags. See set_flag callback in struct tracer.
For now, this file can only receive boolean value on particular options.For example if you have a tracepid option. You either echo tracepid ornotracepid toset the value on trace_option. Your needs would require this file, andthis set_flag callback,to receive string values, like kernel parameters, by using get_option().This way you could set duration=50 as an example.This work is more tracing specific than function-return-tracerspecific (it was renamed function_branchtracer recently).
After that, handling this minimal duration set on function branchtracer will be pretty easy. :-)
One other solution would be to have a dedicated debugfs file for thistracer but that would be a pity, IMHO,to not let too other tracers having custom options with string values.
If you want to have a look on the current state, see the -tip tree.
I will add you in Cc for next patches....ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
