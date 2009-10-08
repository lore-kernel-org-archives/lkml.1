Return-Path: <linux-kernel-owner+w=401wt.eu-S1757499AbZJHVnk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757499AbZJHVnk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Oct 2009 17:43:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757102AbZJHVni
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Oct 2009 17:43:38 -0400
Received: from mail-ew0-f208.google.com ([209.85.219.208]:55494 "EHLO
	mail-ew0-f208.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756023AbZJHVnh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Oct 2009 17:43:37 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=gOrZhQK4R8PV4IAqqubuVTfMO8wkfFnUdSq0YrBBROOgUQQ7DmNH0mpYMRdpVeoSfK
         lz+7ZNWxeoX2SqAWgG+Km/R/J7z6yUSCY1axaMMUrKCiFtBFVmFRtmFsq8rAeDsMROnH
         2b4E3sL9+D3Lir8++t1e1H1bftTu2HqJiLM0M=
Date: Thu, 8 Oct 2009 23:43:00 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Paul Mackerras <paulus@samba.org>
Cc: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
       Steven Rostedt <rostedt@goodmis.org>,
       Peter Zijlstra <peterz@infradead.org>, Li Zefan <lizf@cn.fujitsu.com>
Subject: Re: [PATCH 1/2] tracing: Check total refcount before releasing
	bufs in profile_enable failure
Message-ID: <20091008214258.GH5073@nowhere>
References: <19140.13582.223629.56214@cargo.ozlabs.ibm.com> <1254577650-5623-2-git-send-email-fweisbec@gmail.com> <19148.1579.573095.98045@cargo.ozlabs.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <19148.1579.573095.98045@cargo.ozlabs.ibm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 07, 2009 at 02:08:27PM +1100, Paul Mackerras wrote:
> Frederic Weisbecker writes:
> 
> > When we call the profile_enable() callback of an event, we release the
> > shared perf event tracing buffers unconditionnaly in the failure path.
> > This is wrong because there may be other users of these. Then check the
> > total refcount before doing this.
> 
> [snip]
> 
> > -	kfree(trace_profile_buf_nmi);
> >  fail_buf_nmi:
> > -	kfree(trace_profile_buf);
> > +	if (!total_profile_count) {
> 
> A small problem here: total_profile_count will be 1, not 0, in the
> case where we need to free...
> 
> > +		kfree(trace_profile_buf_nmi);
> > +		kfree(trace_profile_buf);
> > +		trace_profile_buf_nmi = NULL;
> > +		trace_profile_buf = NULL;
> > +	}
> >  fail_buf:
> > -	total_profile_count--;
> 
> since we don't decrement total_profile_count until here.
> 
> Paul.


No, because now we only increment total_profile_count if
nothing has failed. This is even the last thing done
in the succeeded path. So if we fail and need to free, it
means its values is still 0.

