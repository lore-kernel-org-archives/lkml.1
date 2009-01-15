Return-Path: <linux-kernel-owner+w=401wt.eu-S1765044AbZAOOHs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765044AbZAOOHs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2009 09:07:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758074AbZAOOHj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Jan 2009 09:07:39 -0500
Received: from mail-bw0-f21.google.com ([209.85.218.21]:51063 "EHLO
	mail-bw0-f21.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754247AbZAOOHi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2009 09:07:38 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=dUacL0usy6Ox1UpB3tu34xVd05jk0IuQZAEBs08SKRJead3vE8qD6GH06oktMQeJpr
         CaPYL+rp/keEggpHqWi8YyODL44LzBSepSePln376hO18DkbpgtC8FYXvy1QzbRNK/6k
         05G3Y5Fb2QiVWuC2Jg0yWh5flgEVXuabOOU+w=
Message-ID: <25e057c00901150559t14fd3becn5cea005895dacdc4@mail.gmail.com>
Date: Thu, 15 Jan 2009 14:59:35 +0100
From: "roel kluin" <roel.kluin@gmail.com>
To: "Tejun Heo" <tj@kernel.org>
Subject: Re: [patch] add optimized generic percpu accessors
Cc: "Ingo Molnar" <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
       "Brian Gerst" <brgerst@gmail.com>, ebiederm@xmission.com,
       cl@linux-foundation.org, rusty@rustcorp.com.au, travis@sgi.com,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       steiner@sgi.com, hugh@veritas.com
In-Reply-To: <496F346B.6020804@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1231843097-18003-1-git-send-email-tj@kernel.org>
	 <73c1f2160901130527s2d61f4ewf0725c3bf1b36a1a@mail.gmail.com>
	 <496C9FB7.9050907@kernel.org> <496D8CEB.5060402@zytor.com>
	 <20090114093834.GA19799@elte.hu> <496F0F50.6070200@kernel.org>
	 <20090115113045.GG22850@elte.hu> <496F2032.5080502@kernel.org>
	 <20090115122611.GJ22850@elte.hu> <496F346B.6020804@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> +#ifndef percpu_read
> +# define percpu_read(var)                                              \
> +  ({                                                                   \
> +       typeof(per_cpu_var(var)) __tmp_var__;                           \
> +       __tmp_var__ = get_cpu_var(var);                                 \
> +       put_cpu_var(var);                                               \
> +       __tmp_var__;                                                    \
> +  })
> +#endif

I'm sorry for your eyes, but since var occurs twice, isn't it better to do:

# define percpu_read(var)                                              \
  ({                                                                   \
       typeof(var) __pcpu_read_var__ = var;
               \
       typeof(per_cpu_var(__pcpu_read_var__)) __tmp_var__;                    \
       __tmp_var__ = get_cpu_var(__pcpu_read_var__);                           \
       put_cpu_var(__pcpu_read_var__);                                         \
       __tmp_var__;                                                    \
  })

> +
> +#define __percpu_generic_to_op(var, val, op)                           \
> +do {                                                                   \
> +       get_cpu_var(var) op val;                                        \
> +       put_cpu_var(var);                                               \
> +} while (0)

and:

#define __percpu_generic_to_op(var, val, op)                           \
do {                                                                   \
       typeof(var) __pcpu_gto_var__ = var;
              \
       get_cpu_var(__pcpu_gto_var__) op val;
             \
       put_cpu_var(__pcpu_gto_var__);
             \
} while (0)
