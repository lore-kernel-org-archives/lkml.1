Return-Path: <linux-kernel-owner+w=401wt.eu-S932295AbXHXAM2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932295AbXHXAM2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Aug 2007 20:12:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932514AbXHXAMT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Aug 2007 20:12:19 -0400
Received: from waste.org ([66.93.16.53]:48728 "EHLO waste.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753677AbXHXAMS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Aug 2007 20:12:18 -0400
Date: Thu, 23 Aug 2007 19:13:51 -0500
From: Matt Mackall <mpm@selenic.com>
To: Ingo Oeser <ioe-lkml@rameria.de>
Cc: lode leroy <lode_leroy@hotmail.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] memchr (trivial) optimization
Message-ID: <20070824001351.GA20266@waste.org>
References: <BAY105-F323FF3DC8E6C544A2BBE98FFD50@phx.gbl> <200708230213.21332.ioe-lkml@rameria.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200708230213.21332.ioe-lkml@rameria.de>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 23, 2007 at 02:13:20AM +0200, Ingo Oeser wrote:
> On Wednesday 22 August 2007, lode leroy wrote:
> > While profiling something completely unrelated, I noticed
> > that on the workloads I used memchr for, I saw a 30%-40% improvement
> > in performance, with the following trivial changes...
> > (basically, it saves 3 operations for each call)
> 
> Yes, but then you could be a bit more explicit to the compiler
> on what you are doing here:
>  
> void *memchr(const void *s, int c, size_t n)
> {
> 	const unsigned char *p = s;
> 
> 	for (; n != 0; n--, p++) {
>                if ((unsigned char)c == *p) {
>                        return (void *)p;
> 	}
> 	return NULL;
> }
> 
> Now the compiler should see the loop more clearly.

And you can do even better with this:

void *memchr(const void *s, int c, size_t n)
{
       const unsigned char *p = s, *e = s + n;
       const unsigned char *e = p + n;

       for (; p < e ; p++)
                if ((unsigned char)c == *p)
                        return (void *)p;

       return NULL;
}

which changes the inner loop from:

  50:   38 08                   cmp    %cl,(%eax)
  52:   74 08                   je     5c <memchr2+0x1a>
  54:   4a                      dec    %edx
  55:   40                      inc    %eax
  56:   85 d2                   test   %edx,%edx
  58:   75 f6                   jne    50 <memchr2+0xe>

to:

  6e:   38 08                   cmp    %cl,(%eax)
  70:   74 07                   je     79 <memchr3+0x1b>
  72:   40                      inc    %eax
  73:   39 d0                   cmp    %edx,%eax
  75:   72 f7                   jb     6e <memchr3+0x10>


-- 
Mathematics is the supreme nostalgia of our time.
