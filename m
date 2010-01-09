Return-Path: <linux-kernel-owner+w=401wt.eu-S1754530Ab0AIATL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754530Ab0AIATL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jan 2010 19:19:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754340Ab0AIATK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Jan 2010 19:19:10 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56008 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754243Ab0AIATJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jan 2010 19:19:09 -0500
Date: Fri, 8 Jan 2010 16:18:48 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>,
       Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org
Subject: Re: kprobes: get rid of distinct type warning
Message-Id: <20100108161848.1fe19b5e.akpm@linux-foundation.org>
In-Reply-To: <20100105084027.GA5480@osiris.boeblingen.de.ibm.com>
References: <20091221101549.GA3850@osiris.boeblingen.de.ibm.com>
	<20091230132945.f32f49fd.akpm@linux-foundation.org>
	<20100104155702.GB5671@osiris.boeblingen.de.ibm.com>
	<201001050915.41334.rusty@rustcorp.com.au>
	<20100105084027.GA5480@osiris.boeblingen.de.ibm.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 5 Jan 2010 09:40:27 +0100
Heiko Carstens <heiko.carstens@de.ibm.com> wrote:

> On Tue, Jan 05, 2010 at 09:15:41AM +1030, Rusty Russell wrote:
> > On Tue, 5 Jan 2010 02:27:02 am Heiko Carstens wrote:
> > > On Wed, Dec 30, 2009 at 01:29:45PM -0800, Andrew Morton wrote:
> > > > The num_*() "functions" return unsigned on SMP and int on UP.  This is
> > > > wrong.
> > > > 
> > > > The cpu_*() "functions" got lucky and return int in both cases.
> > > > 
> > > > Personally I think it's neatest if a quantity which can never be
> > > > negative is held in an unsigned type.  Than includes anything starting
> > > > with "num".  But for expediency's sake we could live with making these
> > > > things consistently return "int".
> > > > 
> > > > Alas, changing those four num_*() "functions" to return int on SMP is a
> > > > pretty wide-reaching change and will probably expose warts.
> > > 
> > > Looks like there are quite a lot of num_* function usages in the kernel.
> > > Some seem to assume they return an int some assume an unsigned int.
> > > Don't know if it's worth changing anything here.
> > > Maybe Rusty has an opinion.
> > 
> > If we have to go one way or the other, go with unsigned.
> > 
> > What does such a patch look like?
> 
> Something like this, doesn't even trigger new warnings on an !SMP defconfig
> build:
> 
> Subject: [PATCH] cpumask: let num_*_cpus() function always return unsigned values
> 
> From: Heiko Carstens <heiko.carstens@de.ibm.com>
> 
> Dependent on CONFIG_SMP the num_*_cpus() functions return unsigned or
> signed values.
> Let them always return unsigned values to avoid strange casts.
> 
> Signed-off-by: Heiko Carstens <heiko.carstens@de.ibm.com>
> ---
>  include/linux/cpumask.h |    8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)
> 
> --- a/include/linux/cpumask.h
> +++ b/include/linux/cpumask.h
> @@ -90,10 +90,10 @@ extern const struct cpumask *const cpu_a
>  #define cpu_present(cpu)	cpumask_test_cpu((cpu), cpu_present_mask)
>  #define cpu_active(cpu)		cpumask_test_cpu((cpu), cpu_active_mask)
>  #else
> -#define num_online_cpus()	1
> -#define num_possible_cpus()	1
> -#define num_present_cpus()	1
> -#define num_active_cpus()	1
> +#define num_online_cpus()	1U
> +#define num_possible_cpus()	1U
> +#define num_present_cpus()	1U
> +#define num_active_cpus()	1U
>  #define cpu_online(cpu)		((cpu) == 0)
>  #define cpu_possible(cpu)	((cpu) == 0)
>  #define cpu_present(cpu)	((cpu) == 0)

I assume that this fixes the kprobes warning, so 

Commit-ID:  c2ef6661ce62e26a8c0978e521fab646128a144b
Gitweb:     http://git.kernel.org/tip/c2ef6661ce62e26a8c0978e521fab646128a144b
Author:     Heiko Carstens <heiko.carstens@de.ibm.com>
AuthorDate: Mon, 21 Dec 2009 13:02:24 +0100
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Mon, 28 Dec 2009 10:25:31 +0100

becomes unneeded?
