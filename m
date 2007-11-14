Return-Path: <linux-kernel-owner+w=401wt.eu-S1757845AbXKNNbL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757845AbXKNNbL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2007 08:31:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754706AbXKNNaq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Nov 2007 08:30:46 -0500
Received: from rv-out-0910.google.com ([209.85.198.188]:56630 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754446AbXKNNap (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2007 08:30:45 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=G+3/OnDnvd5GXPHG4296XnSY6yZl1e4oSVEAJ98INSJsvz959S+cupbC+c9lBMhEvakuxEIQ/Tgmv5UY+qxU6zO6E7N6o+5srq9tDVjZ3VG5lc05PlLCtFPYZOjtEVEwzDsWWSU/bEETzXM41uvW/Pf/4+PSkKYiGbK4jqVnA+c=
Message-ID: <863e9df20711140530h69df9107g38e293aab278686a@mail.gmail.com>
Date: Wed, 14 Nov 2007 19:00:44 +0530
From: "Abhishek Sagar" <sagar.abhishek@gmail.com>
To: "Srinivasa Ds" <srinivasa@in.ibm.com>
Subject: Re: [PATCH][RFC] kprobes: Add user entry-handler in kretprobes
Cc: linux-kernel@vger.kernel.org, prasanna@in.ibm.com, davem@davemloft.net,
       anil.s.keshavamurthy@intel.com, "Jim Keniston" <jkenisto@us.ibm.com>,
       "Ananth N Mavinakayanahalli" <ananth@in.ibm.com>
In-Reply-To: <473ACCBE.9010308@in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <47389BEB.1000901@gmail.com>
	 <863e9df20711121039t5352a993xc9eeb6bfea123805@mail.gmail.com>
	 <863e9df20711130247g45d3d541j10c76434e9c65b00@mail.gmail.com>
	 <473AAA75.2050900@in.ibm.com>
	 <863e9df20711140049q3ad486ben7ace2edab0a2ca41@mail.gmail.com>
	 <473ACCBE.9010308@in.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Nov 14, 2007 3:53 PM, Srinivasa Ds <srinivasa@in.ibm.com> wrote:
> No, eventhough return instances are chained in an order, order of execution of
> return handler entirely depends on which process returns first

Right...the LIFO chain analogy holds true for return instances for the
same task only. As you've pointed out, kretprobe_instance is the only
thing that can bind corresponding entry and return handlers together,
which has been taken care of.

> So entry_handler() which gets executed last doesn't guarantee
> that its return handler will be executed first(because it took a lot time
> to return).

Only if there are return instances pending belonging to different tasks.

> So only thing to match the entry_handler() with its return_handler() is
> return probe instance(ri)'s address, which user has to take care explicitly

Lets see how entry and return handlers can be matched up in three
different scenarios:-

1. Multiple function entries from various tasks (the one you've just
pointed out).
2. Multiple kretprobe registration on the same function.
3. Nested calls of kretprobe'd function.

In cases 1 and 3, the following information can be used to match
corresponding entry and return handlers inside a user handler (if
needed):

(ri->task, ri->ret_addr)
where ri is struct kretprobe_instance *

This tuple should uniquely identify a return address (right?).


In case 2, entry and return handlers are anyways called in the right
order (taken care of by
trampoline_handler() due to LIFO insertion in ri->hlist).

The fact that ri is passed to both handlers should allow any user
handler to identify each of these cases and take appropriate
synchronization action pertaining to its private data, if needed.

> (Hence I feel sol a) would be nice).

With an entry-handler, any module aiming to profile running time of a
function (say) can simply do the following without being "return
instance" conscious. Note however that I'm not trying to address just
this scenario but trying to provide a general way to use
entry-handlers in kretprobes:

static unsigned  long flag = 0; /* use bit 0 as a global flag */
unsigned long long entry, exit;

int my_entry_handler(struct kretprobe_instance *ri, struct pt_regs *regs)
{
    if (!test_and_set_bit(0, &flag))
    /* this instance claims the first entry to kretprobe'd function */
        entry = sched_clock();
        /* do other stuff */
        return 0; /* right on! */
    }
    return 1; /* error: no return instance to be allocated for this
function entry */
}

/* will only be called iff flag == 1 */
int my_return_handler(struct kretprobe_instance *ri, struct pt_regs *regs)
{
    BUG_ON(!flag);
    exit = sched_clock();
    set_bit(0, &flag);
}

I think something like this should do the trick for you.

> Thanks
>  Srinivasa DS

--
Thanks & Regards
Abhishek Sagar
-
To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
Please read the FAQ at  http://www.tux.org/lkml/
