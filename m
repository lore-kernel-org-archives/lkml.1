Return-Path: <linux-kernel-owner+w=401wt.eu-S1757725AbYEWPJk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757725AbYEWPJk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 May 2008 11:09:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751600AbYEWPJc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 May 2008 11:09:32 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45234 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751439AbYEWPJb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 May 2008 11:09:31 -0400
Date: Fri, 23 May 2008 08:08:57 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Harvey Harrison <harvey.harrison@gmail.com>
cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 3/5] isdn: fix integer as NULL pointer warning
In-Reply-To: <1211496307.6888.10.camel@brick>
Message-ID: <alpine.LFD.1.10.0805230803290.3081@woody.linux-foundation.org>
References: <1211496307.6888.10.camel@brick>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 22 May 2008, Harvey Harrison wrote:
>  	len += sprintf(page+len, "%-16s %s\n", "type", s);
> -	if ((s = cinfo->version[VER_DRIVER]) != 0)
> +	if ((s = cinfo->version[VER_DRIVER]) != NULL)
>  		len += sprintf(page+len, "%-16s %s\n", "ver_driver", s);

For thigns like this (ie testing an assignment), I personally much prefer

	s = cinfo->version[VER_DRIVER];
	if (s)
		len += sprintf(page+len, "%-16s %s\n", "ver_driver", s);

over the uglier and unreadable version.

IOW, testing assignments is good only when:

 - you have to do it because of syntax (ie notably in a "while()" loop)

 - there's some reason you want it to be a single statement (eg doing a 
   macro or other thing)

 - of the assignment is really simple, and the test is not against NULL or 
   zero.

The reason for that "the test is not against NULL or zero" is that testing 
for NULL and 0 is better done with just a "if (x)", and in an assignment 
that just means either (a) a incomprehensible extra parenthesis just to 
shut the compiler up or (b) changing the simple test into a stupid test 
(ie doing "if (x != NULL)").

(b) is much preferable to (a), but just doing it as two statements is 
much preferable to either!

		Linus
