Return-Path: <linux-kernel-owner+w=401wt.eu-S1753500Ab0AROyL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753500Ab0AROyL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jan 2010 09:54:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753445Ab0AROyH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Jan 2010 09:54:07 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:41971 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753423Ab0AROyF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jan 2010 09:54:05 -0500
X-Authority-Analysis: v=1.0 c=1 a=YQwRUT9YnxYA:10 a=7U3hwN5JcxgA:10 a=omOdbC7AAAAA:8 a=4FIa9aocB3aBoMHsYb8A:9 a=WVFvnJgTxtdW_sF5ISPq3x9gM6sA:4 a=xPGKiaK05RZ1OOXB:21 a=GAIDMPSfnQe9UTke:21
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.89.75
Subject: Re: [PATCH 4/7] lib: Introduce strnstr()
From: Steven Rostedt <rostedt@goodmis.org>
Reply-To: rostedt@goodmis.org
To: Alex Riesen <raa.lkml@gmail.com>
Cc: Li Zefan <lizf@cn.fujitsu.com>, Ingo Molnar <mingo@elte.hu>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <81b0412b1001160312x3874bbddj28aac9e5a36bf98a@mail.gmail.com>
References: <4B4E86FB.40208@cn.fujitsu.com>
	 <4B4E8743.6030805@cn.fujitsu.com>
	 <81b0412b1001160312x3874bbddj28aac9e5a36bf98a@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-15"
Organization: Kihon Technologies Inc.
Date: Mon, 18 Jan 2010 09:53:59 -0500
Message-ID: <1263826439.28171.4006.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2010-01-16 at 12:12 +0100, Alex Riesen wrote:
> On Thu, Jan 14, 2010 at 03:53, Li Zefan <lizf@cn.fujitsu.com> wrote:
> > @@ -667,7 +667,7 @@ EXPORT_SYMBOL(memscan);
> >  */
> >  char *strstr(const char *s1, const char *s2)
> >  {
> > -       int l1, l2;
> > +       size_t l1, l2;
> >
> 
> This chunk is not related, is it?

Actually it is related. Making both strstr and strnstr use the correct
variable and be consistent. This patch introduces strnstr and in doing
so also makes strstr consistent (and correct) with strnstr.

> 
> > @@ -684,6 +684,31 @@ char *strstr(const char *s1, const char *s2)
> >  EXPORT_SYMBOL(strstr);
> >  #endif
> >
> > +#ifndef __HAVE_ARCH_STRNSTR
> > +/**
> > + * strnstr - Find the first substring in a length-limited string
> > + * @s1: The string to be searched
> > + * @s2: The string to search for
> > + * @len: the maximum number of characters to search
> > + */
> > +char *strnstr(const char *s1, const char *s2, size_t len)
> > +{
> > +       size_t l1 = len, l2;
> 
> Are you sure you want to search _past_ the NUL-terminator
> of s1?
> 
> > +       l2 = strlen(s2);
> > +       if (!l2)
> > +               return (char *)s1;
> > +       while (l1 >= l2) {
> > +               l1--;

The first check is len-1, I don't see it searching past the
NUL-terminator. The loop will stop when l1 == l2 (the size of s2) and s1
pointing near the end of the string.

-- Steve

> > +               if (!memcmp(s1, s2, l2))
> > +                       return (char *)s1;
> > +               s1++;
> > +       }
> > +       return NULL;
> > +}


