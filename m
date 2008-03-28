Return-Path: <linux-kernel-owner+w=401wt.eu-S1752527AbYC1Hl4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752527AbYC1Hl4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Mar 2008 03:41:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751432AbYC1Hlr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Mar 2008 03:41:47 -0400
Received: from n2.bullet.mail.re3.yahoo.com ([68.142.237.109]:33276 "HELO
	n2.bullet.mail.re3.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751430AbYC1Hlq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Mar 2008 03:41:46 -0400
X-Yahoo-Newman-Id: 665660.74294.bm@omp206.mail.re3.yahoo.com
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=5dQyjyi3SJxz1FQiY2/SEewJA7xBs0F/v7Yaz9/OawMxNnMnOweXE9q5JqujBzXeItokodbtBT35GvwnKFR3JSKVNU1v9ZgjOOLiocDoIEFSfG3hDf7pHl+QxYXXs3XZfaxfYOOYUHgdFYmPArHKJGQF0QbSkwejaNwDeBINDeM=  ;
X-Yahoo-Newman-Property: ymail-3
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: Roel Kluin <12o3l@tiscali.nl>
Subject: Re: [PATCH v2 -mm] likeliness accounting change and cleanup
Date: Fri, 28 Mar 2008 16:09:32 +1100
User-Agent: KMail/1.9.5
Cc: Daniel Walker <dwalker@mvista.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       lkml <linux-kernel@vger.kernel.org>
References: <47EAB608.6060204@tiscali.nl> <1206636313.4670.131.camel@localhost.localdomain> <47EC02A7.5020909@tiscali.nl>
In-Reply-To: <47EC02A7.5020909@tiscali.nl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200803281609.32961.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 28 March 2008 07:25, Roel Kluin wrote:
> Daniel Walker wrote:
> > It's looks good to me .. You'll have to send it to Andrew to get it
> > included tho ..
> >
> > Daniel
>
> Store __builtin_return_address (caller) rather than __func__ in likeliness
> struct. 'line' and 'type' are combined in 'label'
>
> +/- now denotes whether expectation fails in less than 5% of the tests -
> rather than whether more unexpected than expected were encountered. The
> function at the displayed filename & line and the caller are not
> necessarily the same. A few more Likely Profiling Results changes were
> made.
>
> struct seq_operations becomes static, unsigned ints true and false
> (shadowed) are replaced by pos and neg.
>
> Signed-off-by: Roel Kluin <12o3l@tiscali.nl>

Patch looks fine to me.

Acked-by: Nick Piggin <npiggin@suse.de>

>  		if (!test_and_set_bit(0, &likely_lock)) {
> -			if (likeliness->type & LP_UNSEEN) {
> -				likeliness->type &= (~LP_UNSEEN);
> +			if (likeliness->label & LP_UNSEEN) {
> +				likeliness->label &= (~LP_UNSEEN);
>  				likeliness->next = likeliness_head;
>  				likeliness_head = likeliness;
> +				likeliness->caller = (unsigned long)
> +						__builtin_return_address(0);
>  			}
>  			smp_mb__before_clear_bit();
>  			clear_bit(0, &likely_lock);

While you're cleaning up this code, any chance you'd like to
change this to test_and_set_bit_lock() / clear_bit_unlock() ?
(in a 2nd patch).

The current usage is not wrong as such, but the _lock routines are
faster and provide a better example to follow...

