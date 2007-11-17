Return-Path: <linux-kernel-owner+w=401wt.eu-S1761539AbXKQRJ5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761539AbXKQRJ5 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Nov 2007 12:09:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758694AbXKQRJr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 Nov 2007 12:09:47 -0500
Received: from rv-out-0910.google.com ([209.85.198.188]:23074 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751153AbXKQRJp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Nov 2007 12:09:45 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=rAFmxOmDUZSxhYjAAqde0ladNjGSoGqvh1jQLqc1ObNri68UeUeZjaKdIYVHP/tDxZF648yakYBzbU97Fu3i36EOk9v1CQLJYj+1Ja41o4mspFNqiWyPLMDKkCNYcrcreQulrj7GQof5RYcSS/hOX7vc0+VpvIfqSCPOPGQFPLQ=
Message-ID: <863e9df20711170909i7cb24f1aq743e1b645ef0e0b0@mail.gmail.com>
Date: Sat, 17 Nov 2007 22:39:31 +0530
From: "Abhishek Sagar" <sagar.abhishek@gmail.com>
To: "Jim Keniston" <jkenisto@us.ibm.com>
Subject: Re: [PATCH][RFC] kprobes: Add user entry-handler in kretprobes
Cc: "Srinivasa Ds" <srinivasa@in.ibm.com>, linux-kernel@vger.kernel.org,
       prasanna@in.ibm.com, davem@davemloft.net,
       anil.s.keshavamurthy@intel.com,
       "Ananth N Mavinakayanahalli" <ananth@in.ibm.com>
In-Reply-To: <1195254569.8520.37.camel@dyn9047018096.beaverton.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <47389BEB.1000901@gmail.com> <473AAA75.2050900@in.ibm.com>
	 <863e9df20711140049q3ad486ben7ace2edab0a2ca41@mail.gmail.com>
	 <473ACCBE.9010308@in.ibm.com>
	 <863e9df20711140530h69df9107g38e293aab278686a@mail.gmail.com>
	 <1195080664.5781.78.camel@dyn9047018096.beaverton.ibm.com>
	 <863e9df20711150700i3c84374ava108f5b585e8498b@mail.gmail.com>
	 <1195171644.3804.124.camel@dyn9047018096.beaverton.ibm.com>
	 <863e9df20711161053q7f6ae3d5vb19b23d2ce6b20f7@mail.gmail.com>
	 <1195254569.8520.37.camel@dyn9047018096.beaverton.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Nov 17, 2007 4:39 AM, Jim Keniston <jkenisto@us.ibm.com> wrote:
> First of all, as promised, here's what would be different if it were
> implemented using the data-pouch approach:
>
> --- abhishek1.c 2007-11-16 13:57:13.000000000 -0800
> +++ jim1.c      2007-11-16 14:20:39.000000000 -0800
> @@ -50,15 +50,12 @@
>         if (stats)
>                 return 1; /* recursive/nested call */
>
> -       stats = kmalloc(sizeof(struct prof_data), GFP_ATOMIC);
> -       if (!stats)
> -               return 1;
> +       stats = (struct prof_data *) ri->entry_info;
>
>         stats->entry_stamp = sched_clock();
>         stats->task = current;
>         INIT_LIST_HEAD(&stats->list);
>         list_add(&stats->list, &data_nodes);
> -       ri->data = stats;
>         return 0;
>  }
>
> @@ -66,10 +63,9 @@
>  static int return_handler(struct kretprobe_instance *ri, struct pt_regs
> *regs)
>  {
>         unsigned long flags;
> -       struct prof_data *stats = (struct prof_data *)ri->data;
> +       struct prof_data *stats = (struct prof_data *)ri->entry_info;
>         u64 elapsed;
>
> -       BUG_ON(ri->data == NULL);
>         elapsed = (long long)sched_clock() - (long long)stats->entry_stamp;
>
>         /* update stats */
> @@ -79,13 +75,13 @@
>         spin_unlock_irqrestore(&time_lock, flags);
>
>         list_del(&stats->list);
> -       kfree(stats);
>         return 0;
>  }
>
>  static struct kretprobe my_kretprobe = {
>         .handler = return_handler,
>         .entry_handler = entry_handler,
> +       .entry_info_sz = sizeof(struct prof_data)
>  };
>
>  /* called after every PRINT_DELAY seconds */
>
> So the data-pouch approach saves you a little code and a kmalloc/kfree
> round trip on each kretprobe hit.  A kmalloc/kfree round trip is about
> 80 ns on my system, or about 20% of the base cost of a kretprobe hit.  I
> don't know how important that is to people.
>
> I also note that this particular example maintains a per-task list of
> prof_data objects to avoid overcounting the time spent in a recursive
> function.  That adds about 30% to the size of your module source (136
> lines vs. 106, by my count).  I suspect that many instrumentation
> modules wouldn't need such a list.  However, without your ri->data
> pointer (or Kevin's ri->entry_info pouch), every instrumentation module
> that uses your enhancement would need such a list in order to map the ri
> to the per-instance.

Those are interesting numbers. Will incorporate pouching in the next
patch. Even with a data pointer or pouch, the mapping of ri (or
ri->data) would sometimes be necessary. It's required to catch
recursive/nested invocation cases. In case of time measurment test
module, these invocations needed to be weeded out and therefore such a
list was required. Other scenarios might not care for it. E.g a module
which measures the change in some global system state across every
call.

Thanks for the comments.

> Jim

- Abhishek
