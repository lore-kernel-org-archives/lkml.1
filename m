Return-Path: <linux-kernel-owner+w=401wt.eu-S1753624AbZENTGk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753624AbZENTGk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 May 2009 15:06:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753292AbZENTG3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 May 2009 15:06:29 -0400
Received: from mx2.redhat.com ([66.187.237.31]:40612 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751198AbZENTG3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 May 2009 15:06:29 -0400
Date: Thu, 14 May 2009 15:05:21 -0400
From: Josef Bacik <josef@redhat.com>
To: Vitaly Mayatskikh <v.mayatskih@gmail.com>
Cc: Josef Bacik <josef@redhat.com>, sandeen@redhat.com,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/2] sys_write() should write all valid data
Message-ID: <20090514190521.GF10059@dhcp231-156.rdu.redhat.com>
References: <1242317939-15392-1-git-send-email-v.mayatskih@gmail.com> <20090514180234.GB10059@dhcp231-156.rdu.redhat.com> <87eiurzfkd.wl%vmayatsk@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87eiurzfkd.wl%vmayatsk@redhat.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 14, 2009 at 08:48:18PM +0200, Vitaly Mayatskikh wrote:
> At Thu, 14 May 2009 14:02:34 -0400, Josef Bacik wrote:
> 
> > Ok all in all I don't think this is a good way to handle this problem.
> > Hopefully somebody smarter than I will speak up, but what you are trying to do
> > here is have your cake and eat it too.  You want to get the size of what we were
> > able to fault in and return that, which should be a size_t,
> 
> btw, fault_in_pages_readable() has argument `size' of type int...
>

Yeah I noticed that, it should be fixed to be size_t.
 
> > but you also want to
> > throw back an error if something happened, which needs a signed value.  I think
> > the best way to handle this would be to make check_readable_bytes return size_t,
> > and then if you get an EFAULT back, have it return 0.  Then the caller can say
> > "hey I couldn't fault anything in, let me make what I want to fault in smaller",
> > and then if that fault returns 0 we can exit.
> 
> Won't it be suboptimal to trap in the same place twice?
>

Yes, but only in the case we fail to fault in the entire range of userspace
pages we wanted, to which I say "meh" :).  Userspace gave us a bad buffer, I
think having optimal performance in this case isn't a high priority.

The fact of the matter is we need to be return'ing a size_t of the number of
bytes we were able to fault in, so 0 is the only sane way to tell us we weren't
successfull in faulting what we wanted in.  Maybe change what you've currently
done to do the above, and then we just return size_t of what we were able to
fault in, and then the next time we loop around when we get a 0 back we know we
couldn't fault anymore in and return -EFAULT then.  Thanks,

Josef
