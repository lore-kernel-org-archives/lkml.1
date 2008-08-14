Return-Path: <linux-kernel-owner+w=401wt.eu-S1755228AbYHNKEy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755228AbYHNKEy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Aug 2008 06:04:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752557AbYHNKEo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Aug 2008 06:04:44 -0400
Received: from elasmtp-curtail.atl.sa.earthlink.net ([209.86.89.64]:57705 "EHLO
	elasmtp-curtail.atl.sa.earthlink.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752423AbYHNKEm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Aug 2008 06:04:42 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=dk20050327; d=mindspring.com;
  b=l1Prrx9tBRpa/PnJn3f5qsCERONXDsHy4TY+EzIq+qEFBkC8qOO5dS/dq4hilHN5;
  h=Received:Date:From:To:Cc:Subject:Message-Id:In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-ELNK-Trace:X-Originating-IP;
Date: Thu, 14 Aug 2008 06:04:33 -0400
From: Bill Fink <billfink@mindspring.com>
To: David Witbrodt <dawitbro@sbcglobal.net>
Cc: Yinghai Lu <yhlu.kernel@gmail.com>, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Peter Zijlstra <peterz@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       netdev <netdev@vger.kernel.org>
Subject: Re: HPET regression in 2.6.26 versus 2.6.25 -- revert for
 2.6.26-rc1 failed
Message-Id: <20080814060433.684c4fe5.billfink@mindspring.com>
In-Reply-To: <737832.54450.qm@web82101.mail.mud.yahoo.com>
References: <737832.54450.qm@web82101.mail.mud.yahoo.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.8.6; powerpc-yellowdog-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-ELNK-Trace: c598f748b88b6fd49c7f779228e2f6aeda0071232e20db4d4292959c979c94407af20afd57170030350badd9bab72f9c350badd9bab72f9c350badd9bab72f9c
X-Originating-IP: 96.234.158.88
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi David,

On Wed, 13 Aug 2008, David Witbrodt wrote:

> [Yinghai, please note that I did not request a patch to revert the
> problem commit.  I was merely experimenting -- on my own time, so
> you folks would not have to bother -- to see if I could make it
> work.  I should have made that more clear!  Having said that, I am
> glad to test changes of any kind on my machine:  reverts, code for
> debugging or info, experiments, etc.]

I'm not sure Yinghai's revert patch is completely equivalent to
a revert of the original problematic commit, by a side-by-side
comparison of the original commit with his recent revert patch,
but then I don't really know that code at all.

In the original code there was a section (in e820_reserve_resources()):

#ifdef CONFIG_KEXEC
		   if (crashk_res.start != crashk_res.end)
			   request_resource(res, &crashk_res);
#endif

If you don't have CONFIG_KEXEC defined in your .config, which is
probably the case, then you would never request a crashk_res resource.
But in the code after the original commit, it unconditionally calls
(in reserve_crashkernel()):

	   crashk_res.start = crash_base;
	   crashk_res.end   = crash_base + crash_size - 1;
	   insert_resource(&iomem_resource, &crashk_res);

And after Yinghai's revert patch it still does (in reserve_crashkernel()):

        crashk_res.start = crash_base;
        crashk_res.end   = crash_base + crash_size - 1;
        crashk_res_ptr = &crashk_res;

and (in setup_arch()):

	num_res = 3;
	if (crashk_res_ptr) {
		res_kernel[num_res] = crashk_res_ptr;
		num_res++;
	}
	e820_reserve_resources(res_kernel, num_res);

then (in e820_reserve_resources()):

			for (j = 0; j < nr_res_k; j++) {
				if (!res_kernel[j])
					continue;
				request_resource(res, res_kernel[j]);
			}

which for j == 3 is:

	request_resource(res, &crashk_res);

Now it would appear that the new:

	insert_resource(&iomem_resource, &crashk_res);

or new:

	request_resource(res, &crashk_res);

should be noops.  But if for any reason crash_size is not zero,
then there could be a difference.  I have no idea if this is at all
significant, but I thought I'd point it out just in case.

						-Bill
