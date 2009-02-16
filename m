Return-Path: <linux-kernel-owner+w=401wt.eu-S1752722AbZBPOqk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752722AbZBPOqk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Feb 2009 09:46:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750876AbZBPOqb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Feb 2009 09:46:31 -0500
Received: from ns2.suse.de ([195.135.220.15]:50393 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750807AbZBPOqb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Feb 2009 09:46:31 -0500
From: Thomas Renninger <trenn@suse.de>
Organization: SUSE Products GmbH
To: =?utf-8?q?=C3=89ric_Piel?= <eric.piel@tremplin-utc.net>
Subject: Re: [PATCH] cpufreq: Governor poll frequency tuneables exported in config.
Date: Mon, 16 Feb 2009 15:46:27 +0100
User-Agent: KMail/1.10.3 (Linux/2.6.27.13-HEAD_20090130075504_71baee03-default; KDE/4.1.3; x86_64; ; )
Cc: Mike Chan <mike@android.com>, davej@codemonkey.org.uk,
       linux-kernel@vger.kernel.org, cpufreq@vger.kernel.org
References: <1234469284-15924-1-git-send-email-mike@android.com> <49996B42.5040500@tremplin-utc.net>
In-Reply-To: <49996B42.5040500@tremplin-utc.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200902161546.28630.trenn@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 16 February 2009 14:33:54 Éric Piel wrote:
> Mike Chan schreef:
> >     cpufreq: Governor poll frequency tuneables exported in config.
> >     
> Hello,
> 
> > +config CPU_FREQ_MIN_TICKS
> > +	int "Ticks between governor polling interval."
> > +	default 10
> > +	help
> > +	  Minimum number of ticks between polling interval for governors.
> I don't think it makes much sense to let anyone tune this parameter.
> This is a constant that says we need at least a 10% granularity to
> compute any statistic correctly. There is nothing much to be discussed
> or tuned.
> 
> 
> > +config CPU_FREQ_SAMPLING_LATENCY_MULTIPLIER
> > +	int "Sampling rate multiplier for governors."
> > +	default 1000
> > +	help
> > +	  Sampling latency rate multiplied by the cpu switch latency.
> > +	  Affects governor polling.
> This one, why not (although I don't think it's worth neither), and it
> would need a better documentation.
It is already configurable in userspace, no need to introduce a 
new config variable:

Documentation/cpu-freq/governors.txt

==================
sampling_rate: measured in uS (10^-6 seconds), this is how often you
want the kernel to look at the CPU usage and to make decisions on
what to do about the frequency.  Typically this is set to values of
around '10000' or more. It's default value is (cmp. with users-guide.txt):
transition_latency * 1000
The lowest value you can set is:
transition_latency * 100 or it may get restricted to a value where it
makes not sense for the kernel anymore to poll that often which depends
on your HZ config variable (HZ=1000: max=20000us, HZ=250: max=5000).
Be aware that transition latency is in ns and sampling_rate is in us, so 
you
get the same sysfs value by default.
Sampling rate should always get adjusted considering the transition latency
To set the sampling rate 750 times as high as the transition latency
in the bash (as said, 1000 is default), do:
echo `$(($(cat cpuinfo_transition_latency) * 750 / 1000)) \
    >ondemand/sampling_rate
===================

But this is only in the very latest cpufreq next tree and should pop up
in 2.6.30.

Hmm, the statement:
"Typically this is set to values of around '10000' or more"
Is wrong (E.g. if you have HZ=250 you cannot go below 80000), but I plan to 
touch this again soon. Then this statement hopefully is correct again.

    Thomas
