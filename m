Return-Path: <linux-kernel-owner+w=401wt.eu-S1751782AbXCEW7X@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751782AbXCEW7X (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Mar 2007 17:59:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752150AbXCEW7X
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Mar 2007 17:59:23 -0500
Received: from smtp008.mail.ukl.yahoo.com ([217.12.11.62]:27737 "HELO
	smtp008.mail.ukl.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751782AbXCEW7V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Mar 2007 17:59:21 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.it;
  h=Received:X-YMail-OSG:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=QvBqti1KvEvAwP5wHVp7U4xg2EXN384cr22FyqtJJD0MplNJTsKUj4XPrNkH4PWIufW6jrnisoTrXaAkPL2uXpHXjkPDQVT+r/Sl3fiW86HdSWJC2um8P8VfP50xJKpWXsrq5RbDOo5KqkZvFpn9N/60GbrB3ptrV5OniDavSUw=  ;
X-YMail-OSG: W2kScMoVM1nEIyISL1ASboVC3ooKxdcs97kUpLjs6yggyloJGgog6M71f.TERkPg0._1nSKeY3eA6Y4nQTX_GO0W8ruGL.LchzgYI5TZDuRdB9Y6q5EQxQ3bxxpHu4F7UbO8TnvvJ5RLkxwTXNX9lFM-
From: Blaisorblade <blaisorblade@yahoo.it>
To: user-mode-linux-devel@lists.sourceforge.net
Subject: Re: [uml-devel] [PATCH 04/11] uml - hostfs: avoid possible escapes from hostfs=.
Date: Mon, 5 Mar 2007 23:59:13 +0100
User-Agent: KMail/1.9.5
Cc: Jeff Dike <jdike@addtoit.com>, Andrew Morton <akpm@osdl.org>,
       linux-kernel@vger.kernel.org
References: <20070305204229.9072.17032.stgit@americanbeauty.home.lan> <20070305204902.9072.1224.stgit@americanbeauty.home.lan> <20070305220334.GB7702@ccure.user-mode-linux.org>
In-Reply-To: <20070305220334.GB7702@ccure.user-mode-linux.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200703052359.13612.blaisorblade@yahoo.it>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 05 March 2007 23:03, Jeff Dike wrote:
> On Mon, Mar 05, 2007 at 09:49:02PM +0100, Paolo 'Blaisorblade' Giarrusso 
wrote:
> > From: Paolo 'Blaisorblade' Giarrusso <blaisorblade@yahoo.it>
> >
> > Avoid accepting things like -o .., -o dir/../../dir2, -o dir/../.. .
> > This may be considered useless, but YMMV. I consider that this has a
> > limited security value, exactly like disabling module support (in many
> > case it is useful).
>
> Two comments on this one:
> > +	return  strstr(path, "/../") != NULL ||
> > +		strcmp(path, "..") == 0 ||
> > +		strncmp(path, "../", strlen("../")) == 0 ||
> > +		str_ends_with(path, "/..");
>
> Minor style point - I'd be happier with more parens:
>
> +	return  (strstr(path, "/../") != NULL) ||
> +		(strcmp(path, "..") == 0) ||
> +		(strncmp(path, "../", strlen("../")) == 0) ||
> +		str_ends_with(path, "/..");

Hmm. Personally I prefer the earlier style, but I haven't the last word on 
this.

> C gets operator precedence wrong in one or two cases, so I just put parens
> any place it might matter.

Indeed. For instance this patch is wrong, I did this once in a patch, and I 
saw it another time in current Ubuntu kernels:

-	a + b / 4
+	a + b >> 2

This is instead needed:

+	a + (b >> 2)

> Second, there is code in externfs which does the same thing without
> parsing paths which you might consider instead.

I must, indeed - your comment points out the symlink issue, which I didn't 
think of, and which makes my patch moot.

> It sees whether the 
> requested directory is outside the jail by cd-ing to it and then
> repeatedly cd .. until it either reaches / or the jail root.
>
> A copy is below for your reading pleasure.

I gave a look, and it's nice. Except that maybe "escapes_jail" would be a 
clearer name (there's confusion about the subject of "escaping").

Also, what about concurrent UML threads caring about current directory? I know 
that without SMP/preemption we can't have this problem, but when I see this I 
count a future bug unless this is checked (I think I reason mathematically 
about correctness, even if not formally).

And I haven't the time to check this - I think your version could be merged 
anyway, but I'm not sure.

> 				Jeff

-- 
Inform me of my mistakes, so I can add them to my list!
Paolo Giarrusso, aka Blaisorblade
http://www.user-mode-linux.org/~blaisorblade
Chiacchiera con i tuoi amici in tempo reale! 
 http://it.yahoo.com/mail_it/foot/*http://it.messenger.yahoo.com 
