Return-Path: <linux-kernel-owner+w=401wt.eu-S1757350AbZCOE1j@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757350AbZCOE1j (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Mar 2009 00:27:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752894AbZCOE1a
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Mar 2009 00:27:30 -0400
Received: from smtp128.sbc.mail.sp1.yahoo.com ([69.147.65.187]:20870 "HELO
	smtp128.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751357AbZCOE13 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Mar 2009 00:27:29 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:Reply-To:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=qwM0FYcJMnKxJGNxl+KSGLcWhU6y3L8cZd1zEH9+M9jG/xI9a1qGX3hLeGL3Ms/cJhczR49VcAyR8/eADuZzrwaVrrh3+5UAIaCJ1wI3bX1SadW4vqNasnsAto2VDpiLssA6ThNpSZaOigKCRualV3M5TDw/Cp+BHKb2dO+z/jI=  ;
X-YMail-OSG: O389pL8VM1kbyGw9ljCGhljgOEDu9EsNyCobFdyVkmBEm2azqKqn5ymniW_Yd5COB9l7qtJdVURTVCmy2LdRvG.9.mqM62xiKmMwIe5Iaf7ZbILfAYg7bXM6vtWp9HURcibtlgvZxbbXDRmKc3E1JYyQ
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
Reply-To: dbrownell@users.sourceforge.net
To: Mark Brown <broonie@sirena.org.uk>
Subject: Re: [patch 2.6.29-rc7 regulator-next] regulator: refcount fixes
Date: Sat, 14 Mar 2009 21:27:26 -0700
User-Agent: KMail/1.9.10
Cc: Liam Girdwood <lrg@slimlogic.co.uk>, lkml <linux-kernel@vger.kernel.org>,
       OMAP <linux-omap@vger.kernel.org>
References: <200903111743.34708.david-b@pacbell.net> <200903141429.24534.david-b@pacbell.net> <20090315003039.GA11052@sirena.org.uk>
In-Reply-To: <20090315003039.GA11052@sirena.org.uk>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8bit
Content-Disposition: inline
Message-Id: <200903142127.26182.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 14 March 2009, Mark Brown wrote:
> Looking at things from the point of view of the consumer I just don't
> find that it makes any difference since as far as the consumer is
> concerned it's all opaque objects manipulated via an API.

These put()/get() calls are not refcount calls.  They're
what might be called alloc()/free() calls instead.

>         foo = foo_get(dev, name);

The normal idiom is

	bar = foo_get(foo)

which just increments a refcount.  Then if "bar" were handed
to something else ("baz") right here, and "baz" needed to keep a
copy of that reference, it would be expected to grab its own
refcount via foo_get(bar), and later release via foo_put(bar).


>         foo_enable(foo);
>         foo_disable(foo);
>         foo_put(foo);

Until "baz" called foo_put(bar), that reference would still be
usable.  But ... regulator_put(foo) does a kfree, it's not
just updating refcounts.
