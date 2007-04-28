Return-Path: <linux-kernel-owner+w=401wt.eu-S1752770AbXD1HvF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752770AbXD1HvF (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Apr 2007 03:51:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753078AbXD1HvF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Apr 2007 03:51:05 -0400
Received: from smtp1.linux-foundation.org ([65.172.181.25]:43484 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752770AbXD1HvB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Apr 2007 03:51:01 -0400
Date: Sat, 28 Apr 2007 00:50:28 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Simon Arlott <simon@fire.lp0.eu>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Duncan Sands <duncan.sands@math.u-psud.fr>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: Re: [PATCH (rev 2)] cxacru: Cleanup sysfs attribute code
Message-Id: <20070428005028.54f1b621.akpm@linux-foundation.org>
In-Reply-To: <462FA0D0.9040901@simon.arlott.org.uk>
References: <462E730F.3090401@simon.arlott.org.uk>
	<200704250919.50382.duncan.sands@math.u-psud.fr>
	<11882.simon.1177499883@5ec7c279.invalid>
	<462FA0D0.9040901@simon.arlott.org.uk>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 25 Apr 2007 19:41:20 +0100 Simon Arlott <simon@fire.lp0.eu> wrote:

> This changes the format of unknown status values to be less verbose and 
> uses an array instead of several different snprintf calls. Since only 
> enum values are assigned to it, poll_state is changed from int to enum. 
> Use abs() for dB values instead of two almost identical return lines.
> 
> Signed-off-by: Simon Arlott <simon@fire.lp0.eu>
> Cc: Greg Kroah-Hartman <gregkh@suse.de>
> Cc: Duncan Sands <duncan.sands@math.u-psud.fr>
> Cc: Andrew Morton <akpm@linux-foundation.org>
>
> ...
>  
>  static ssize_t cxacru_sysfs_showattr_bool(u32 value, char *buf)
>  {
> -	switch (value) {
> -	case 0: return snprintf(buf, PAGE_SIZE, "no\n");
> -	case 1: return snprintf(buf, PAGE_SIZE, "yes\n");
> -	default: return 0;
> -	}
> +	static char *str[] = { "no", "yes" };
> +	if (unlikely(value >= ARRAY_SIZE(str)))
> +		return snprintf(buf, PAGE_SIZE, "%u\n", value);
> +	return snprintf(buf, PAGE_SIZE, "%s\n", str[value]);
>  }

Should a bool be displayed as "true" or "false"?

>  static ssize_t cxacru_sysfs_showattr_LINK(u32 value, char *buf)
>  {
>
> ...
>
> +		return snprintf(buf, PAGE_SIZE, "%u\n", value);
>  }

To be completely pedantic: we shouldn't be printing u32's with %u.  Because
%u assumes that u32 is implemented as unsigned int.  Only it's an opaque
type and we don't know what actual C type the architecture chose to use.

It happens to work OK on all architectures and I expect it always will, so
no change is needed, but there you have it.

u64's and %llu _are_ incompatible on some architectures and I get to fix
that about 1000000 times.

