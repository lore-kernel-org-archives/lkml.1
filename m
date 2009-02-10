Return-Path: <linux-kernel-owner+w=401wt.eu-S1755849AbZBJUWV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755849AbZBJUWV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Feb 2009 15:22:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753896AbZBJUWM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Feb 2009 15:22:12 -0500
Received: from fg-out-1718.google.com ([72.14.220.155]:26102 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753436AbZBJUWL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Feb 2009 15:22:11 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=Rxq1IGuFmyaY5fvbiapEf7r/3CFAv49I5jpbJUTgagXlF85/pcTTKvnrxltYuJ0PYN
         syfSrCNR4skx1Xh8g9dOq1ByzjV1l9We+KAt0A9ieg+341XfiwkzXIcWvMpAsqM+IH0E
         /6iM+mwqpl3gc0DLUqHs+CNVZXuw9lCk0/aic=
Subject: Re: [PATCH, for 2.6.29] ptrace: fix the usage of ptrace_fork()
From: Markus Metzger <markus.t.metzger@googlemail.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: "Metzger, Markus T" <markus.t.metzger@intel.com>,
       Ingo Molnar <mingo@elte.hu>, Roland McGrath <roland@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Markus Metzger <markus.t.metzger@googlemail.com>
In-Reply-To: <20090210184014.GA30545@redhat.com>
References: <20090209010233.GA26444@redhat.com>
	 <20090209012824.GA26461@redhat.com>
	 <928CFBE8E7CB0040959E56B4EA41A77E4A1E7C8B@irsmsx504.ger.corp.intel.com>
	 <20090209193625.GA4808@redhat.com>
	 <928CFBE8E7CB0040959E56B4EA41A77E4A1E82FE@irsmsx504.ger.corp.intel.com>
	 <20090210184014.GA30545@redhat.com>
Content-Type: text/plain
Date: Tue, 10 Feb 2009 21:21:59 +0100
Message-Id: <1234297319.6112.23.camel@raistlin>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-02-10 at 19:40 +0100, Oleg Nesterov wrote:

> > 2. there is a race between a thread detaching
> > and another thread releasing the same task.

I think I now see the problem. Ptrace uses the tasklist_lock to protect
against __ptrace_unlink() races.

I could either introduce a separate lock to protect bts buffer
deallocation, or I put the kfree part under the tasklist_lock,
as you suggest below.



> Perhaps, for 2.6.29, we can do something like the "patch" below?
> 
> (btw, do you agree with the change in copy_process() I sent? )

Both patches look good to me.


> --- a/arch/x86/kernel/ptrace.c
> +++ b/arch/x86/kernel/ptrace.c
> @@ -810,11 +810,15 @@ static void ptrace_bts_untrace(struct ta
>  
>  static void ptrace_bts_detach(struct task_struct *child)
>  {
> +	// We can race with de_thread/do_wait which
> +	// can do ptrace_bts_untrace() before us
>  	if (unlikely(child->bts)) {
> -		ds_release_bts(child->bts);
> -		child->bts = NULL;
> -
> -		ptrace_bts_free_buffer(child);
> +		// This all will be freed by ptrace_bts_untrace()
> +		// later, but we should update ->mm
> +		down_write(->mmap_sem);
> +		mm->total_vm  -= bts_size;
> +		mm->locked_vm -= bts_size);
> +		up_write(->mmap_sem);
>  	}
>  }
>  #else
> 


You already sent out the first one. I don't have access to any
test machine from home. I could send the patch tomorrow (evening).

thanks and regards,
markus.

