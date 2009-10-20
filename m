Return-Path: <linux-kernel-owner+w=401wt.eu-S1751764AbZJTVxQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751764AbZJTVxQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Oct 2009 17:53:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751069AbZJTVxP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Oct 2009 17:53:15 -0400
Received: from mail-ew0-f207.google.com ([209.85.219.207]:47915 "EHLO
	mail-ew0-f207.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751044AbZJTVxO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Oct 2009 17:53:14 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=lv4v6NoMRpA+eqMy/R4G4c+0X3ZEblUJOOPwb5CBLYgC5CsYXRbUSm2VywvNLi08Jz
         ewN8R7l4C33aJ/a0xpYXwO+ltyNaeuQRqfaISF4l6LDYTiL/0TWjPY/p/m7Gvjg+Y96b
         35Qfe3dVD1WtNYvwGFCYY0Zl+Ke3PY0kPyIto=
Date: Tue, 20 Oct 2009 23:53:14 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Anton Blanchard <anton@samba.org>
Cc: mingo@elte.hu, paulus@samba.org, a.p.zijlstra@chello.nl,
       linux-kernel@vger.kernel.org
Subject: Re: perf report fractal output issue
Message-ID: <20091020215311.GB4975@nowhere>
References: <20091014225726.GF4808@kryten> <20091015122839.GA4960@nowhere> <20091015234126.GI4808@kryten>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091015234126.GI4808@kryten>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 16, 2009 at 10:41:26AM +1100, Anton Blanchard wrote:
> 
> Hi,
> 
> > > It looks like callchain__fprintf_graph() only prints the callchain if we
> > > have at least one rb entry at the top. In my case all the associated
> > > backtraces are identical so I assume we dont have to do any splitting.
> >
> > Hmm, could you please send me a perf.data where you can see that?
> > Does that only happen on powerpc?
> 
> I can replicate this on x86 by taking a perf.data and truncating it
> after the first sample+backtrace:
> 
> 
> # wget http://samba.org/~anton/perf_truncated.test
> 
> 
> # perf report -i perf_truncated.test -g fractal
> ...
>    100.00%     perf  [kernel]       [k] native_write_msr_safe
> 
> 
> # perf report -i perf_truncated.test -g flat
> ...
>    100.00%     perf  [kernel]       [k] native_write_msr_safe
>            100.00%
>                 native_write_msr_safe
>                 intel_pmu_enable_all
>                 hw_perf_enable
>                 perf_enable
>                 __perf_counter_enable
>                 smp_call_function_single
>                 task_oncpu_function_call
>                 perf_counter_enable
>                 perf_counter_for_each_child
>                 perf_ioctl
>                 vfs_ioctl
>                 do_vfs_ioctl
>                 sys_ioctl
>                 system_call_fastpath
>                 0x7f00c1857537


Thanks, I can reproduce it with your file.
Actually it was there from the beginning but we have missed it:
the root of the callchain is never printed :-s

Say you have:

hist_entry
    |
    --------- f1
              f2
              |
              -------- f3
              |        f4
              |
              ---------f5
                       f6

Actually you never see that, instead you have:

hist_entry
    |
    --------- f3
    |         f4
    |
    --------- f5
              f6

Thanks a lot for this report!
I'm currently fixing it.

I just hope the fix won't be too big for .32 ....

