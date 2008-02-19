Return-Path: <linux-kernel-owner+w=401wt.eu-S1753895AbYBSNmI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753895AbYBSNmI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2008 08:42:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751896AbYBSNl4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Feb 2008 08:41:56 -0500
Received: from wx-out-0506.google.com ([66.249.82.232]:10627 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751595AbYBSNlz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2008 08:41:55 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=WlOq9xw9CB962lZqPvXRyPZbk/htI0mWiSl4Sni8LB1FSM81wFG7MgIfxKVY33O0lZ60O+pm6tEdQwkTf2oO79pLQLGexz5CjcOWAkw1xdgeYq5qNeMlalEjYlj1niZead1x3+gVWInIqHO8fnwjImTERWe+2XmqWcE4j8CWP5c=
Message-ID: <b647ffbd0802190541k1428623fv23f000642c75d43b@mail.gmail.com>
Date: Tue, 19 Feb 2008 14:41:52 +0100
From: "Dmitry Adamushko" <dmitry.adamushko@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: Re: [PATCH, RFC] kthread: (possibly) a missing memory barrier in kthread_stop()
Cc: "Nick Piggin" <nickpiggin@yahoo.com.au>, "Ingo Molnar" <mingo@elte.hu>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Rusty Russel" <rusty@rustcorp.com.au>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       "Andy Whitcroft" <apw@shadowen.org>,
       "Peter Zijlstra" <a.p.zijlstra@chello.nl>
In-Reply-To: <1203413060.10858.82.camel@lappy>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1203375817.7619.73.camel@earth>
	 <200802191744.45281.nickpiggin@yahoo.com.au>
	 <1203413060.10858.82.camel@lappy>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

btw.,

(a bit more of 'nit-picking' :-)

to work properly, kthread_stop() should also impose one of the
following requirements on a 'kthread' loop:

- a loop can be interrupted _only_ as a result of
'kthread_should_stop() == true'
and no concurrent kthread_stop() calls are possible;

or

- if it can exit due to another reason, a user has to use additional
synchronization means to make sure than kthread_stop() is never
called/running after a main loop has finished (makes sense as 'struct
task_struct *' can be 'obsolete')

otherwise,

note, the comment in kthread() that says "It might have exited on its
own, w/o kthread_stop.  Check."

so let's suppose a 'kthread' is really "exiting on its own" and at the
same time, kthread_stop() is running on another CPU... as a result, we
may end up with kthread_stop() being blocked on
wait_for_completion(&kthread_stop_info.done) without anybody to call
complete().

Although, the requirements above don't seem to be so insane in this case.


static int kthread(void *_create)
{
...
         if (!kthread_should_stop())
                ret = threadfn(data);     <---- our main loop is
inside this function

         /* It might have exited on its own, w/o kthread_stop.  Check. */
         if (kthread_should_stop()) {
                 kthread_stop_info.err = ret;
                 complete(&kthread_stop_info.done);
         }
         return 0;
}

-- 
Best regards,
Dmitry Adamushko
