Return-Path: <linux-kernel-owner+w=401wt.eu-S1760756AbZFIMwi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760756AbZFIMwi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Jun 2009 08:52:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756083AbZFIMwb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Jun 2009 08:52:31 -0400
Received: from wf-out-1314.google.com ([209.85.200.175]:65468 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755547AbZFIMwa convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Jun 2009 08:52:30 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=Y6FUQ8NvTMa1vXfakCQvUAu4ragZOAfJazJDPBKiPrAlr9VfYavliikFX28mcUNHo+
         +XjNktht9ZiRv1fG5hRc7SVfeXJ3gRtt/ZPSh4qz0gl7t/zmY1ZD2dpMjK/dSVqW/FGP
         p3WsYw6LJqxMpB/I5/NoGVkhPxKhrb8P/fYuU=
MIME-Version: 1.0
In-Reply-To: <20090608235043.02660ce4@linux-lm>
References: <1243781365-26814-1-git-send-email-tom.leiming@gmail.com>
	 <1244463727.13761.8700.camel@twins> <20090608235043.02660ce4@linux-lm>
Date: Tue, 9 Jun 2009 20:52:32 +0800
Message-ID: <d82e647a0906090552h4d201b25rd321dcfd021192b6@mail.gmail.com>
Subject: Re: [PATCH 0/8] kernel:lockdep:replace DFS with BFS
From: Ming Lei <tom.leiming@gmail.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: mingo@elte.hu, linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2009/6/8 Ming Lei <tom.leiming@gmail.com>:
> I have fixed the bug, which is introduced in your patch:
>        lockdep: clean up after BFS patches.
>
> Please apply and verify the patch,thanks.

Hi, Peter

Would you mind verifying the patch which fixes your kernel boot failure?

If it does work,  What do we need to do for this patches being accepted
by tip-tree?

Thanks.

>
> I'll go to bed,:-)
>
> From e99ce7b2b4985032e9f54b08a7790f3df2783286 Mon Sep 17 00:00:00 2001
> From: Ming Lei <tom.leiming@gmail.com>
> Date: Mon, 8 Jun 2009 23:38:59 +0800
> Subject: [PATCH] kernel:lockdep:fix return value of check_usage*()
>
> Return zero if BFS find the target, so fix return value of callers
> of BFS.
>
> The patch fixes the boot failure introduced by the patch:
>        lockdep: clean up after BFS patches
> .
>
> Signed-off-by: Ming Lei <tom.leiming@gmail.com>
> ---
>  kernel/lockdep.c |   20 ++++++++++++--------
>  1 files changed, 12 insertions(+), 8 deletions(-)
>
> diff --git a/kernel/lockdep.c b/kernel/lockdep.c
> index 09a141f..48c3364 100644
> --- a/kernel/lockdep.c
> +++ b/kernel/lockdep.c
> @@ -1250,8 +1250,6 @@ find_usage_forwards(struct lock_list *root, enum lock_usage_bit bit,
>        debug_atomic_inc(&nr_find_usage_forwards_checks);
>
>        result = __bfs_forwards(root, (void *)bit, usage_match, target_entry);
> -       if (result < 0)
> -               return print_bfs_bug(result);
>
>        return result;
>  }
> @@ -1275,8 +1273,6 @@ find_usage_backwards(struct lock_list *root, enum lock_usage_bit bit,
>        debug_atomic_inc(&nr_find_usage_backwards_checks);
>
>        result = __bfs_backwards(root, (void *)bit, usage_match, target_entry);
> -       if (result < 0)
> -               return print_bfs_bug(result);
>
>        return result;
>  }
> @@ -1397,13 +1393,17 @@ check_usage(struct task_struct *curr, struct held_lock *prev,
>
>        this.class = hlock_class(prev);
>        ret = find_usage_backwards(&this, bit_backwards, &target_entry);
> -       if (!ret || ret == 1)
> +       if (ret < 0)
> +               return print_bfs_bug(ret);
> +       if (ret == 1)
>                return ret;
>
>        that.parent = NULL;
>        that.class = hlock_class(next);
>        ret = find_usage_forwards(&that, bit_forwards, &target_entry1);
> -       if (!ret || ret == 1)
> +       if (ret < 0)
> +               return print_bfs_bug(ret);
> +       if (ret == 1)
>                return ret;
>
>        return print_bad_irq_dependency(curr, &this, &that,
> @@ -2088,7 +2088,9 @@ check_usage_forwards(struct task_struct *curr, struct held_lock *this,
>        root.parent = NULL;
>        root.class = hlock_class(this);
>        ret = find_usage_forwards(&root, bit, &target_entry);
> -       if (!ret || ret == 1)
> +       if (ret < 0)
> +               return print_bfs_bug(ret);
> +       if (ret == 1)
>                return ret;
>
>        return print_irq_inversion_bug(curr, &root, target_entry,
> @@ -2110,7 +2112,9 @@ check_usage_backwards(struct task_struct *curr, struct held_lock *this,
>        root.parent = NULL;
>        root.class = hlock_class(this);
>        ret = find_usage_backwards(&root, bit, &target_entry);
> -       if (!ret || ret == 1)
> +       if (ret < 0)
> +               return print_bfs_bug(ret);
> +       if (ret == 1)
>                return ret;
>
>        return print_irq_inversion_bug(curr, &root, target_entry,
> --
> 1.6.0.GIT
>
>
>
>
> --
> Lei Ming
>



-- 
Lei Ming
