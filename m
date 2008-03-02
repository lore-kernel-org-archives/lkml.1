Return-Path: <linux-kernel-owner+w=401wt.eu-S1758709AbYCBW2t@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758709AbYCBW2t (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Mar 2008 17:28:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752772AbYCBW2i
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Mar 2008 17:28:38 -0500
Received: from el-out-1112.google.com ([209.85.162.179]:28586 "EHLO
	el-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752237AbYCBW2i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Mar 2008 17:28:38 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=ahMplK0InWMnbCJT5miUkEz6Eu5Fy/NzBNVPtgpWaqVATlPpo5yuJZ6nctBFuC3NEKVMVMPl0yl9U2Y2uro0ac+FDlz4t9+kQQ8/pxGmRp1Nbp7sR1IpKNbRCweaLzi3VUidsYs8FveB8nxtYCEPXmhnLofBOD+irX56A2v6wWE=
Message-ID: <b647ffbd0803021428h277ed1e0q6d302f0ae9392346@mail.gmail.com>
Date: Sun, 2 Mar 2008 23:28:35 +0100
From: "Dmitry Adamushko" <dmitry.adamushko@gmail.com>
To: "Rusty Russell" <rusty@rustcorp.com.au>
Subject: Re: [PATCH 1/2] kthread: add a missing memory barrier to kthread_stop()
Cc: "Andrew Morton" <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       "Nick Piggin" <nickpiggin@yahoo.com.au>, "Ingo Molnar" <mingo@elte.hu>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       "Peter Zijlstra" <a.p.zijlstra@chello.nl>,
       "Andy Whitcroft" <apw@shadowen.org>
In-Reply-To: <200803030850.57615.rusty@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1203543390.6307.24.camel@earth>
	 <200803030850.57615.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/03/2008, Rusty Russell <rusty@rustcorp.com.au> wrote:
> On Thursday 21 February 2008 08:36:30 Dmitry Adamushko wrote:
>  > From: Dmitry Adamushko <dmitry.adamushko@gmail.com>
>  > Subject: kthread: add a missing memory barrier to kthread_stop()
>  >
>  > We must ensure that kthread_stop_info.k has been updated before
>  > kthread's wakeup. This is required to properly support
>  > the use of kthread_should_stop() in the main loop of kthread.
>  >
>  > wake_up_process() doesn't imply a full memory barrier,
>  > so we add an explicit one.
>
>
> I always believed that wake_up_process() implies a write barrier.  It's pretty
>  common to set something up then wake the intended recipient.

No, it didn't imply a write mb. Moreover, the situation I tried to
address required a full mb (write vs. read ops. synchronization).

Please take a look at the discussion here http://lkml.org/lkml/2008/2/23/238

and here is a more detailed description of the problem :
http://groups.google.com/group/fa.linux.kernel/browse_thread/thread/44c45685680585fc/e58785df0eeee6f8?lnk=raot

>
>  So I think this patch is overkill, but I'm happy to be corrected.

We ended up adding an explicit smp_wmb() (a patch by Linus) to the
very beginning of try_to_wake_up(). Combined with the following
spin_lock() it acts as a 'full' mb for write vs. read ('read' takes
place inside try_to_wake_up()) and that's exactly what we need here.

The 1st link mentioned above may provide more details for interested readers.

So yes, now that we have got smp_wmb() in try_to_wake_up() this patch
is redundant.


>
>  Thanks!
>
> Rusty.
>


-- 
Best regards,
Dmitry Adamushko
