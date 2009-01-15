Return-Path: <linux-kernel-owner+w=401wt.eu-S1765535AbZAOVv7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765535AbZAOVv7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2009 16:51:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753731AbZAOVvq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Jan 2009 16:51:46 -0500
Received: from hera.kernel.org ([140.211.167.34]:33486 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753597AbZAOVvp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2009 16:51:45 -0500
Message-ID: <496FAFC7.8040205@kernel.org>
Date: Fri, 16 Jan 2009 06:51:03 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: roel kluin <roel.kluin@gmail.com>
CC: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
       Brian Gerst <brgerst@gmail.com>, ebiederm@xmission.com,
       cl@linux-foundation.org, rusty@rustcorp.com.au, travis@sgi.com,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       steiner@sgi.com, hugh@veritas.com
Subject: Re: [patch] add optimized generic percpu accessors
References: <1231843097-18003-1-git-send-email-tj@kernel.org>	 <73c1f2160901130527s2d61f4ewf0725c3bf1b36a1a@mail.gmail.com>	 <496C9FB7.9050907@kernel.org> <496D8CEB.5060402@zytor.com>	 <20090114093834.GA19799@elte.hu> <496F0F50.6070200@kernel.org>	 <20090115113045.GG22850@elte.hu> <496F2032.5080502@kernel.org>	 <20090115122611.GJ22850@elte.hu> <496F346B.6020804@kernel.org> <25e057c00901150559t14fd3becn5cea005895dacdc4@mail.gmail.com>
In-Reply-To: <25e057c00901150559t14fd3becn5cea005895dacdc4@mail.gmail.com>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Thu, 15 Jan 2009 21:51:08 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Roel.

roel kluin wrote:
>> +#ifndef percpu_read
>> +# define percpu_read(var)                                              \
>> +  ({                                                                   \
>> +       typeof(per_cpu_var(var)) __tmp_var__;                           \
>> +       __tmp_var__ = get_cpu_var(var);                                 \
>> +       put_cpu_var(var);                                               \
>> +       __tmp_var__;                                                    \
>> +  })
>> +#endif
> 
> I'm sorry for your eyes, but since var occurs twice, isn't it better to do:
> 
> # define percpu_read(var)                                              \
>   ({                                                                   \
>        typeof(var) __pcpu_read_var__ = var;
>                \
>        typeof(per_cpu_var(__pcpu_read_var__)) __tmp_var__;                    \
>        __tmp_var__ = get_cpu_var(__pcpu_read_var__);                           \
>        put_cpu_var(__pcpu_read_var__);                                         \
>        __tmp_var__;                                                    \
>   })
> 
>> +
>> +#define __percpu_generic_to_op(var, val, op)                           \
>> +do {                                                                   \
>> +       get_cpu_var(var) op val;                                        \
>> +       put_cpu_var(var);                                               \
>> +} while (0)
> 
> and:
> 
> #define __percpu_generic_to_op(var, val, op)                           \
> do {                                                                   \
>        typeof(var) __pcpu_gto_var__ = var;
>               \
>        get_cpu_var(__pcpu_gto_var__) op val;
>              \
>        put_cpu_var(__pcpu_gto_var__);
>              \
> } while (0)

@var has to be simple identifier as it ends up getting concatenated to
a string.  There's even a check for it in get_cpu_var() macro.  Please
also note that lack of any protecting ()'s around @var for the same
reason.  So, basically, typeof(var) just doesn't exist.

Thanks.

-- 
tejun
