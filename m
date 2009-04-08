Return-Path: <linux-kernel-owner+w=401wt.eu-S934607AbZDHR3w@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934607AbZDHR3w (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Apr 2009 13:29:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753100AbZDHR3l
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Apr 2009 13:29:41 -0400
Received: from mail-bw0-f169.google.com ([209.85.218.169]:34315 "EHLO
	mail-bw0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751718AbZDHR3k convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Apr 2009 13:29:40 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=gilsEye0bo8K5AAX6VGiDpmJMOSew9kJSbF1gnqx822crF5lbDNRc6XVJO90lMUzrs
         HBhmriE57bGsm2/0znqH/Cc1vdq2K6Sa8pj77NaCzT6Gy3vRpKUcO2TWr26F29LEJJCR
         ScAM/cU8+c8LkKgn8wcCN4fTOvVsp++fv9bgk=
MIME-Version: 1.0
In-Reply-To: <200904051620.02311.bart.vanassche@gmail.com>
References: <200904051620.02311.bart.vanassche@gmail.com>
Date: Wed, 8 Apr 2009 19:29:38 +0200
Message-ID: <e2e108260904081029u621e46bbmc95cff280f70085c@mail.gmail.com>
Subject: Re: [2.6.29] Fix for enabling branch profiling makes sparse unusable
From: Bart Van Assche <bart.vanassche@gmail.com>
To: Steven Rostedt <srostedt@redhat.com>, Ingo Molnar <mingo@elte.hu>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Apr 5, 2009 at 4:20 PM, Bart Van Assche
<bart.vanassche@gmail.com> wrote:
> One of the changes between kernels 2.6.28 and 2.6.29 is that a branch profiler
> has been added for if() statements. Unfortunately this patch makes the sparse
> output unusable with CONFIG_TRACE_BRANCH_PROFILING=y: when branch profiling is
> enabled, sparse prints so much false positives that the real issues are no
> longer visible. This behavior can be reproduced as follows:
> * enable CONFIG_TRACE_BRANCH_PROFILING, e.g. by running make allyesconfig or
>  make allmodconfig.
> * run make C=2
>
> Result: a huge number of the following sparse warnings.
> ...
> include/linux/cpumask.h:547:2: warning: symbol '______r' shadows an earlier one
> include/linux/cpumask.h:547:2: originally declared here
> ...
>
> The patch below fixes this by disabling branch profiling while analyzing the
> kernel code with sparse.
>
> See also:
> * http://lkml.org/lkml/2008/11/21/18
> * http://bugzilla.kernel.org/show_bug.cgi?id=12925
>
> Signed-off-by: Bart Van Assche <bart.vanassche@gmail.com>
>
> --- orig/linux-2.6.29/include/linux/compiler.h  2009-03-23 19:12:14.000000000 -0400
> +++ linux-2.6.29/include/linux/compiler.h       2009-03-24 08:46:46.000000000 -0400
> @@ -75,7 +75,8 @@ struct ftrace_branch_data {
>  * Note: DISABLE_BRANCH_PROFILING can be used by special lowlevel code
>  * to disable branch tracing on a per file basis.
>  */
> -#if defined(CONFIG_TRACE_BRANCH_PROFILING) && !defined(DISABLE_BRANCH_PROFILING)
> +#if defined(CONFIG_TRACE_BRANCH_PROFILING) \
> +    && !defined(DISABLE_BRANCH_PROFILING) && !defined(__CHECKER__)
>  void ftrace_likely_update(struct ftrace_branch_data *f, int val, int expect);
>
>  #define likely_notrace(x)      __builtin_expect(!!(x), 1)

(ping)

Hello,

Is there any chance the above patch will get included in the 2.6.30 kernel ?

Bart.
