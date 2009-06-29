Return-Path: <linux-kernel-owner+w=401wt.eu-S1759541AbZF2PhK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759541AbZF2PhK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jun 2009 11:37:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753916AbZF2Pg4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Jun 2009 11:36:56 -0400
Received: from x35.xmailserver.org ([64.71.152.41]:47319 "EHLO
	x35.xmailserver.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750731AbZF2Pgz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jun 2009 11:36:55 -0400
X-AuthUser: davidel@xmailserver.org
Date: Mon, 29 Jun 2009 08:34:55 -0700 (PDT)
From: Davide Libenzi <davidel@xmailserver.org>
X-X-Sender: davide@makko.or.mcafeemobile.com
To: Jiri Olsa <jolsa@redhat.com>
cc: netdev@vger.kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       fbl@redhat.com, nhorman@redhat.com, davem@redhat.com, htejun@gmail.com,
       jarkao2@gmail.com, oleg@redhat.com, eric.dumazet@gmail.com
Subject: Re: [PATCH 1/2] net: adding memory barrier to the poll and receive
 callbacks
In-Reply-To: <20090629141445.GF3845@jolsa.lab.eng.brq.redhat.com>
Message-ID: <alpine.DEB.1.10.0906290826300.29966@makko.or.mcafeemobile.com>
References: <20090629140434.GE3845@jolsa.lab.eng.brq.redhat.com> <20090629141445.GF3845@jolsa.lab.eng.brq.redhat.com>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
X-GPG-FINGRPRINT: CFAE 5BEE FD36 F65E E640  56FE 0974 BF23 270F 474E
X-GPG-PUBLIC_KEY: http://www.xmailserver.org/davidel.asc
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 29 Jun 2009, Jiri Olsa wrote:

> -static inline void poll_wait(struct file * filp, wait_queue_head_t * wait_address, poll_table *p)
> +static inline void __poll_wait(struct file *filp,
> +				wait_queue_head_t *wait_address, poll_table *p)
> +{
> +	p->qproc(filp, wait_address, p);
> +}
> +
> +static inline void poll_wait(struct file *filp,
> +				wait_queue_head_t *wait_address, poll_table *p)
>  {
>  	if (p && wait_address)
> -		p->qproc(filp, wait_address, p);
> +		__poll_wait(filp, wait_address, p);
>  }

> +static inline void sock_poll_wait(struct file *filp, struct sock *sk,
> +		poll_table *p)
> +{
> +	if (p && sk->sk_sleep) {
> +		__poll_wait(filp, sk->sk_sleep, p);
> +		/*
> +		 * We need to be sure we are in sync with the
> +		 * socket flags modification.
> +		 *
> +		 * This memory barrier is paired in the sk_has_sleeper.
> +		*/
> +		smp_mb();
> +	}
> +}

I think Oleg already said this, but you can use directly poll_wait() 
without adding another abstraction, and the compiler will drop the double 
check for you:

extern void foo(int, int, int);
extern void mb(void);

static inline void cfoo(int a, int b, int c) {
	if (b && c)
		foo(a, b, c);
}

void xxx(int a, int b, int c) {
	if (b && c) {
		cfoo(a, b, c);
		mb();
	}
}
-----
xxx:
	subq	$8, %rsp
	testl	%esi, %esi
	je	.L3
	testl	%edx, %edx
	je	.L3
	call	foo
	addq	$8, %rsp
	jmp	mb
.L3:
	addq	$8, %rsp
	ret



- Davide


