Return-Path: <linux-kernel-owner+w=401wt.eu-S1753373AbYACTyl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753373AbYACTyl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jan 2008 14:54:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751579AbYACTye
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Jan 2008 14:54:34 -0500
Received: from pasmtpa.tele.dk ([80.160.77.114]:34794 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751445AbYACTyd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jan 2008 14:54:33 -0500
Date: Thu, 3 Jan 2008 20:54:34 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH/RFC] kconfig hints/tips/tricks
Message-ID: <20080103195434.GB21227@uranus.ravnborg.org>
References: <20071112161755.430633a2.randy.dunlap@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071112161755.430633a2.randy.dunlap@oracle.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 12, 2007 at 04:17:55PM -0800, Randy Dunlap wrote:
> I'm not very happy with hint #2.  I struggled with ways to express it
> and finally decided to ship it^W^W release early/release often.  :)
> Suggestions welcome.
> 
> ---
> From: Randy Dunlap <randy.dunlap@oracle.com>
> 
> Add a section on kconfig hints: how to do <something> in Kconfig files.
> 
> Fix a few typos/spellos.

Applied as is.

	Sam

> 
> Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
> ---
>  Documentation/kbuild/kconfig-language.txt |   54 ++++++++++++++++++++---
>  1 file changed, 48 insertions(+), 6 deletions(-)
> 
> --- linux-2.6.24-rc2-git2.orig/Documentation/kbuild/kconfig-language.txt
> +++ linux-2.6.24-rc2-git2/Documentation/kbuild/kconfig-language.txt
> @@ -24,7 +24,7 @@ visible if its parent entry is also visi
>  Menu entries
>  ------------
>  
> -Most entries define a config option, all other entries help to organize
> +Most entries define a config option; all other entries help to organize
>  them. A single configuration option is defined like this:
>  
>  config MODVERSIONS
> @@ -50,7 +50,7 @@ applicable everywhere (see syntax).
>  
>  - type definition: "bool"/"tristate"/"string"/"hex"/"int"
>    Every config option must have a type. There are only two basic types:
> -  tristate and string, the other types are based on these two. The type
> +  tristate and string; the other types are based on these two. The type
>    definition optionally accepts an input prompt, so these two examples
>    are equivalent:
>  
> @@ -108,7 +108,7 @@ applicable everywhere (see syntax).
>  	equal to 'y' without visiting the dependencies. So abusing
>  	select you are able to select a symbol FOO even if FOO depends
>  	on BAR that is not set. In general use select only for
> -	non-visible symbols (no promts anywhere) and for symbols with
> +	non-visible symbols (no prompts anywhere) and for symbols with
>  	no dependencies. That will limit the usefulness but on the
>  	other hand avoid the illegal configurations all over. kconfig
>  	should one day warn about such things.
> @@ -162,9 +162,9 @@ An expression can have a value of 'n', '
>  respectively for calculations). A menu entry becomes visible when it's
>  expression evaluates to 'm' or 'y'.
>  
> -There are two types of symbols: constant and nonconstant symbols.
> -Nonconstant symbols are the most common ones and are defined with the
> -'config' statement. Nonconstant symbols consist entirely of alphanumeric
> +There are two types of symbols: constant and non-constant symbols.
> +Non-constant symbols are the most common ones and are defined with the
> +'config' statement. Non-constant symbols consist entirely of alphanumeric
>  characters or underscores.
>  Constant symbols are only part of expressions. Constant symbols are
>  always surrounded by single or double quotes. Within the quote, any
> @@ -301,3 +301,45 @@ mainmenu:
>  
>  This sets the config program's title bar if the config program chooses
>  to use it.
> +
> +
> +Kconfig hints
> +-------------
> +This is a collection of Kconfig tips, most of which aren't obvious at
> +first glance and most of which have become idioms in several Kconfig
> +files.
> +
> +Build as module only
> +~~~~~~~~~~~~~~~~~~~~
> +To restrict a component build to module-only, qualify its config symbol
> +with "depends on m".  E.g.:
> +
> +config FOO
> +	depends on BAR && m
> +
> +limits FOO to module (=m) or disabled (=n).
> +
> +
> +Build limited by a third config symbol which may be =y or =m
> +~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> +A common idiom that we see (and sometimes have problems with) is this:
> +
> +When option C in B (module or subsystem) uses interfaces from A (module
> +or subsystem), and both A and B are tristate (could be =y or =m if they
> +were independent of each other, but they aren't), then we need to limit
> +C such that it cannot be built statically if A is built as a loadable
> +module.  (C already depends on B, so there is no dependency issue to
> +take care of here.)
> +
> +If A is linked statically into the kernel image, C can be built
> +statically or as loadable module(s).  However, if A is built as loadable
> +module(s), then C must be restricted to loadable module(s) also.  This
> +can be expressed in kconfig language as:
> +
> +config C
> +	depends on A = y || A = B
> +
> +or for real examples, use this command in a kernel tree:
> +
> +$ find . -name Kconfig\* | xargs grep -ns "depends on.*=.*||.*=" | grep -v orig
> +
> -
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
