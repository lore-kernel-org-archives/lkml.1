Return-Path: <linux-kernel-owner+w=401wt.eu-S1755161AbZCFOc7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755161AbZCFOc7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Mar 2009 09:32:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753874AbZCFOct
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Mar 2009 09:32:49 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:46182 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753864AbZCFOct (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Mar 2009 09:32:49 -0500
Date: Fri, 6 Mar 2009 15:32:37 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Markus Metzger <markus.t.metzger@intel.com>
Cc: linux-kernel@vger.kernel.org, tglx@linutronix.de, hpa@zytor.com,
       markus.t.metzger@gmail.com, roland@redhat.com, eranian@googlemail.com,
       oleg@redhat.com, juan.villacis@intel.com, ak@linux.jf.intel.com
Subject: Re: [patch 1/4] x86, bts: add selftest for BTS
Message-ID: <20090306143237.GC21907@elte.hu>
References: <20090305161711.A16434@sedona.ch.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090305161711.A16434@sedona.ch.intel.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Markus Metzger <markus.t.metzger@intel.com> wrote:

> +#ifdef CONFIG_X86_DS_SELFTEST
> +static int ds_selftest_bts_consistency(const struct bts_trace *trace)

Consider putting this into ds_selftest.c instead of adding a 
large #ifdef block to ds.c.

> +	if (trace->ds.end !=
> +	    (char *) trace->ds.begin + (trace->ds.n * trace->ds.size)) {

That extra space character after the type cast is not 
needed.

> +	/* Check a few things which do not belong to this test.
> +	 * They should be covered by other tests. */

Please use the customary comment style of:

  /*
   * Comment .....
   * ...... goes here:
   */

> +		index = ((void *) at - trace->ds.begin) / trace->ds.size;

cast.

> +#define DS_SELFTEST_SIZEOF_BUFFER 1021 /* intentionally chose an odd size */
> +static int ds_selftest_bts(void)

We put newlines after definitions.

Also, DS_SELFTEST_SIZEOF_BUFFER is an odd name - why not 
DS_SELFTEST_BUFFER_SIZE ?

> +	tracer =
> +		ds_request_bts(/* task = */ NULL, buffer,
> +			       DS_SELFTEST_SIZEOF_BUFFER,
> +			       /* ovfl = */ NULL, /* th = */ (size_t)-1,
> +			       BTS_KERNEL);

that looks weird. Why not:

	tracer = ds_request_bts(NULL, buffer, DS_SELFTEST_BUFFER_SIZE,
				NULL, (size_t)-1, BTS_KERNEL);

> +	/* The return from the initialization call should already give
> +	 * us enough trace. */

Comment style.

> +		/* It is possible but highly unlikely that we got a
> +		 * buffer overflow and end up at exactly the same
> +		 * position we started from.
> +		 * Let's issue a warning, but continue. */

ditto.

> +	/* Let's read the trace again. Since we suspended tracing, we should
> +	 * get the same result. */

ditto.

> +		/* It is possible but highly unlikely that we got a
> +		 * buffer overflow and end up at exactly the same
> +		 * position we started from.
> +		 * Let's issue a warning and check the full trace. */

ditto.

> +		/* We had a buffer overflow - the entire buffer should
> +		 * contain trace records. */

ditto.

> +		/* It is quite likely that the buffer did not
> +		 * overflow. Let's just check the delta trace. */

ditto.

> +#ifdef CONFIG_X86_DS_SELFTEST
> +	if (ds_cfg.ctl[dsf_bts]) {
> +		int error;
> +
> +		printk(KERN_INFO "[ds] bts selftest...");
> +		error = ds_selftest_bts();
> +		printk(KERN_CONT "%s.\n", (error ? "failed" : "passed"));
> +
> +		if (error) {
> +			WARN(1, "[ds] selftest failed. disabling bts.\n");
> +			ds_cfg.ctl[dsf_bts] = 0;
> +		}
> +	}
> +#endif /* CONFIG_X86_DS_SELFTEST */

This bit should be in a helper function i guess - so the ugly 
#ifdef goes out of a function.

Thanks,

	Ingo
