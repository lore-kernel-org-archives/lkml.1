Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752970Ab0CFB3M (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Mar 2010 20:29:12 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:46176 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751899Ab0CFB3K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Mar 2010 20:29:10 -0500
X-Authority-Analysis: v=1.0 c=1 a=KDX7HhSo8L4A:10 a=7U3hwN5JcxgA:10 a=Q9fys5e9bTEA:10 a=meVymXHHAAAA:8 a=pGLkceISAAAA:8 a=20KFwNOVAAAA:8 a=VnNF1IyMAAAA:8 a=tgXuCA3ck3lxc8DbpbwA:9 a=0dCdEvf3W2xUJRDZuXpJjxq67_QA:4 a=PUjeQqilurYA:10 a=jeBq3FmKZ4MA:10 a=MSl-tDqOz04A:10 a=jEp0ucaQiEUA:10
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.89.75
Subject: Re: [PATCH tip/core/rcu 1/3] ftrace: replace
 read_barrier_depends() with rcu_dereference_raw()
From: Steven Rostedt <rostedt@goodmis.org>
Reply-To: rostedt@goodmis.org
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, laijs@cn.fujitsu.com,
       dipankar@in.ibm.com, akpm@linux-foundation.org,
       mathieu.desnoyers@polymtl.ca, josh@joshtriplett.org, dvhltc@us.ibm.com,
       niv@us.ibm.com, tglx@linutronix.de, peterz@infradead.org,
       Valdis.Kletnieks@vt.edu, dhowells@redhat.com,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Ingo Molnar <mingo@redhat.com>
In-Reply-To: <1267830207-9474-1-git-send-email-paulmck@linux.vnet.ibm.com>
References: <20100305230256.GA9410@linux.vnet.ibm.com>
	 <1267830207-9474-1-git-send-email-paulmck@linux.vnet.ibm.com>
Content-Type: text/plain; charset="ISO-8859-15"
Organization: Kihon Technologies Inc.
Date: Fri, 05 Mar 2010 20:29:05 -0500
Message-ID: <1267838945.10871.1786.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-03-05 at 15:03 -0800, Paul E. McKenney wrote:
> Replace the calls to read_barrier_depends() in ftrace_list_func() with
> rcu_dereference_raw() to improve readability.  The reason that we use
> rcu_dereference_raw() here is that removed entries are never freed,
> instead they are simply leaked.  This is one of a very few cases where
> use of rcu_dereference_raw() is the long-term right answer.  And I don't
> yet know of any others.  ;-)
> 
> Cc: Steven Rostedt <rostedt@goodmis.org>

Acked-by: Steven Rostedt <rostedt@goodmis.org>

Thanks Paul!

> Cc: Frederic Weisbecker <fweisbec@gmail.com>
> Cc: Ingo Molnar <mingo@redhat.com>
> Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> ---

>  
> @@ -154,8 +159,7 @@ static int __register_ftrace_function(struct ftrace_ops *ops)
>  	 * the ops->next pointer is valid before another CPU sees
>  	 * the ops pointer included into the ftrace_list.
>  	 */
> -	smp_wmb();
> -	ftrace_list = ops;
> +	rcu_assign_pointer(ftrace_list, ops);

[ Off topic ]

I looked at rcu_assign_pointer() and it is:

#define rcu_assign_pointer(p, v) \
	({ \
		if (!__builtin_constant_p(v) || \
		    ((v) != NULL)) \
			smp_wmb(); \
		(p) = (v); \
	})

My question is, why that crazy if? The only time that will fail is if we
are assigning the constant NULL to p. What makes NULL so important here?
Can't there be a case when assigning NULL to p will require that wmb()?

-- Steve


>  
>  	if (ftrace_enabled) {
>  		ftrace_func_t func;


