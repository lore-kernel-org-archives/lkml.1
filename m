Return-Path: <linux-kernel-owner+w=401wt.eu-S1030283AbXDKTsb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030283AbXDKTsb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2007 15:48:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030254AbXDKTsb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Apr 2007 15:48:31 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:4610 "EHLO spitz.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1030283AbXDKTsa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2007 15:48:30 -0400
Date: Wed, 11 Apr 2007 19:36:00 +0000
From: Pavel Machek <pavel@ucw.cz>
To: Egmont Koblinger <egmont@uhulinux.hu>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] console UTF-8 fixes
Message-ID: <20070411193559.GA5881@ucw.cz>
References: <20070406191245.GA11974@uhulinux.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070406191245.GA11974@uhulinux.hu>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> I hope you like it. :)

Well, more or less... but you need signed-off-by line, and

> @@ -70,6 +70,16 @@
>   * malformed UTF sequences represented as sequences of replacement glyphs,
>   * original codes or '?' as a last resort if replacement glyph is undefined
>   * by Adam Tla/lka <atlka@pg.gda.pl>, Aug 2006
> + *
> + * More robust UTF-8 decoder. Make it work on malformed sequences as Markus Kuhn's
> + * UTF-8 decoder stress test suggests. Emit a U+FFFD on illegal sequences as well
> + * as for invalid Unicode code points.
> + * If U+FFFD is not available in the font, print an inverse question mark instead.
> + * Display an inverted dot for valid characters that are not available in the font.
> + * Do not print zero-width characters, pad double-width characters with an extra
> + * space so that the cursor moves by zero/two positions in these cases.
> + * 6 April 2007, Egmont Koblinger <egmont@uhulinux.hu>,
> + * using Markus Kuhn's wcwidth() implementation.
>   */

We no longer put changelogs in code.

> +/* wcwidth() based on the implementation by
> + * Markus Kuhn -- 2003-05-20 (Unicode 4.0)
> + * Latest version: http://www.cl.cam.ac.uk/~mgk25/ucs/wcwidth.c
> + */
> +struct interval {
> +  int first;
> +  int last;
> +};
> +
> +static int bisearch(long ucs, const struct interval *table, int max) {
> +  int min = 0;
> +  int mid;
> +
> +  if (ucs < table[0].first || ucs > table[max].last)
> +    return 0;

...and you really need to read coding style.

> +  while (max >= min) {
> +    mid = (min + max) / 2;
> +    if (ucs > table[mid].last)
> +      min = mid + 1;
> +    else if (ucs < table[mid].first)
> +      max = mid - 1;
> +    else
> +      return 1;
> +  }
> +
> +  return 0;
> +}

(Don't we already have rbtrees handling this just fine?)

							Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
