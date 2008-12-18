Return-Path: <linux-kernel-owner+akpm=40linux-foundation.org-S1751660AbYLRPzA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751660AbYLRPzA (ORCPT <rfc822;akpm@linux-foundation.org>);
	Thu, 18 Dec 2008 10:55:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752095AbYLRPyn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Dec 2008 10:54:43 -0500
Received: from e3.ny.us.ibm.com ([32.97.182.143]:57100 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752026AbYLRPym (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Dec 2008 10:54:42 -0500
Subject: Re: [RFC v11][PATCH 05/13] Dump memory address space
From: Dave Hansen <dave@linux.vnet.ibm.com>
To: Oren Laadan <orenl@cs.columbia.edu>
Cc: Mike Waychison <mikew@google.com>, jeremy@goop.org, arnd@arndb.de,
        linux-api@vger.kernel.org, containers@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Linux Torvalds <torvalds@linux-foundation.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@elte.hu>
In-Reply-To: <494A2F94.2090800@cs.columbia.edu>
References: <1228498282-11804-1-git-send-email-orenl@cs.columbia.edu>
	 <1228498282-11804-6-git-send-email-orenl@cs.columbia.edu>
	 <4949B4ED.9060805@google.com>  <494A2F94.2090800@cs.columbia.edu>
Content-Type: text/plain
Date: Thu, 18 Dec 2008 07:54:36 -0800
Message-Id: <1229615676.17206.518.camel@nimitz>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2008-12-18 at 06:10 -0500, Oren Laadan wrote:
> >> +    for (i = pgarr->nr_used; i--; /**/)
> >> +        page_cache_release(pgarr->pages[i]);
> > 
> > This is sorta hard to read (and non-intuitive).  Is it easier to do:
> > 
> > for (i = 0; i < pgarr->nr_used; i++)
> >     page_cache_release(pgarr->pages[i]);
> > 
> > It shouldn't matter what order you release the pages in..
> 
> Was meant to avoid a dereference to 'pgarr->nr_used' in the comparison.
> (though I doubt if the performance impact is at all visible)

That's a bit to aggressive an optimization.  You two piqued my
curiosity, so I tried a little experiment with this .c file:

extern void bar(int i);

struct s {
        int *array;
        int size;
};

extern struct s *s;
void foo(void)
{
        int i;
#ifdef OREN
        for (i = s->size; i--; )
#else
        for (i = 0; i < s->size; i++)
#endif
                bar(s->array[i]);
}

for O in "" -O -O1 -O2 -O3 -Os; do
	gcc -DOREN $O -c f1.c -o oren.o;
	gcc $O -c f1.c -o mike.o;
	echo -n Oren:; objdump -d oren.o | grep ret;
	echo -n Mike:; objdump -d mike.o | grep ret;
done

Smaller numbers are better, and indicate the size of that function,
basically:

Oren:  38:	c3                   	ret    
Mike:  3b:	c3                   	ret    
Oren:  44:	c3                   	ret    
Mike:  36:	c3                   	ret    
Oren:  44:	c3                   	ret    
Mike:  36:	c3                   	ret    
Oren:  43:	c3                   	ret    
Mike:  34:	c3                   	ret    
Oren:  43:	c3                   	ret    
Mike:  34:	c3                   	ret    
Oren:  3a:	c3                   	ret    
Mike:  2a:	c3                   	ret    

gcc version 4.2.4 (Ubuntu 4.2.4-1ubuntu3).  In all but the unoptimized
case, Mike's version wins.  Readability, and icache footprint all in one
package!

-- Dave

