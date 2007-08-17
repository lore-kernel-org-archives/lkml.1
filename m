Return-Path: <linux-kernel-owner+w=401wt.eu-S1765645AbXHQS2J@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765645AbXHQS2J (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Aug 2007 14:28:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756500AbXHQS1m
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Aug 2007 14:27:42 -0400
Received: from smtp111.sbc.mail.re2.yahoo.com ([68.142.229.94]:47469 "HELO
	smtp111.sbc.mail.re2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754270AbXHQS1l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Aug 2007 14:27:41 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=WdO8Pe2IZzReM55LPUW3qlhch3sOw8IXDLrMa2SDRI7I7D7zVnTSS+Xgd3XKQrFn2vTeUuANBpXtw1XeBiu0bxdVp0EcxWR0tOsQo4nmpU3t3yuuwIhQ4WSRu7n9qPegvPc2ZklPA63RNAUU2enPhhMZ9183dO7PuOgmsTNdusg=  ;
X-YMail-OSG: 61CGjaEVM1kCajwQu9xePgGy.SGvw2MtsT2jp4ragPt2rV7AKofoaFTKKLYf1G7F6Qi5v_GIYZmAgxG9bgxcby4HNiFeCgHH.rbeWTUCnZldeYFzHDuoMCDaes2dYJDKD2kMoCtzYzSmog--
From: David Brownell <david-b@pacbell.net>
To: Bryan Wu <bryan.wu@analog.com>
Subject: Re: [PATCH 01/12] Blackfin arch: add peripheral resource allocation support
Date: Fri, 17 Aug 2007 11:12:04 -0700
User-Agent: KMail/1.9.6
Cc: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org,
       Michael Hennerich <michael.hennerich@analog.com>
References: <11865441373719-git-send-email-bryan.wu@analog.com> <11865441391829-git-send-email-bryan.wu@analog.com>
In-Reply-To: <11865441391829-git-send-email-bryan.wu@analog.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200708171112.04697.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 07 August 2007, Bryan Wu wrote:
> From: Michael Hennerich <michael.hennerich@analog.com>

The patch description here is IMO misleading, and is clearly
weak-to-nonexistent ...  what this patch does is

 * Start tracking the label strings provided by gpio_request()
 * Provide a new portmux mechanisms
 * Start using those in the serial support code

When I read "resource allocation" I think of "struct resource"
from <linux/ioport.h>, allocate_resource(), and so on.  So while
it's true there are other kinds of driver resource, it's rather
unnatural for me to think about pin mux and gpio issues in any
terms other than chip and board setup.


> +static int cmp_label(unsigned short ident, const char *label)
> +{
> +	if (label && str_ident)
> +		return strncmp(str_ident + ident * RESOURCE_LABEL_SIZE,
> +				 label, strlen(label));
> +	else
> +		return -EINVAL;
> +}

GRPIO labels are purely for diagnostics.  There's no reason to
compare one to another.  You seem to be using these for purposes
in addition to GPIOs though ... probably worth commenting on that
unusual scheme.


> +int peripheral_request(unsigned short per, const char *label)
> +{
> +	...
> +
> +	if (unlikely(reserved_peri_map[gpio_bank(ident)] & gpio_bit(ident))) {
> +
> +	/*
> +	 * Pin functions like AMC address strobes my
> +	 * be requested and used by several drivers
> +	 */
> +
> +	if (!(per & P_MAYSHARE)) {

Goofy indentation.  And as a rule, drivers have been kept out of
the business of configuring pin usage.  It's simpler that way;
they don't need to try coping with configuration errors like two
drivers wanting conflicting usage ... or as you say above, needing
some explicit sharing mechanism ...


> +
> +	/*
> +	 * Allow that the identical pin function can
> +	 * be requested from the same driver twice
> +	 */

... or as you say here, needing to structure themselves so they
don't configure the same usage more than once ...


That said, how you handle pinmux on Blackfin is your business.

But you should know that this approach seems idiosyncratic and
more complex than needed:  when pin config is done early and as
part of board setup, drivers don't need to care about it or to
handle any pinmux errors.  And heck, products can sometimes be
shipped with the bootloader having done all pinmux setup, so
Linux won't need to worry about it at all.  That can help ship
multiple board revisions using the same kernel.

- Dave



