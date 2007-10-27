Return-Path: <linux-kernel-owner+w=401wt.eu-S1753539AbXJ0Xrj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753539AbXJ0Xrj (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Oct 2007 19:47:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751691AbXJ0Xra
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 27 Oct 2007 19:47:30 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:48410 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751293AbXJ0Xr3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Oct 2007 19:47:29 -0400
Date: Sun, 28 Oct 2007 00:47:19 +0100
From: Al Viro <viro@ftp.linux.org.uk>
To: "Ahmed S. Darwish" <darwish.07@gmail.com>
Cc: casey@schaufler-ca.com, akpm@osdl.org, torvalds@osdl.org,
       linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] Version 9 (2.6.24-rc1) Smack: Simplified Mandatory Access Control Kernel
Message-ID: <20071027234719.GU8181@ftp.linux.org.uk>
References: <4720118C.5020906@schaufler-ca.com> <20071027090112.GA5460@Ahmed>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071027090112.GA5460@Ahmed>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 27, 2007 at 11:01:12AM +0200, Ahmed S. Darwish wrote:
> The problem here (As discussed in private mails) is that the for loop 
> assumes that the beginning of given user-space buffer is the beginning
> of a rule. This leads to situations where the rule becomes "ecret 20",
> or "cret 20" instead of "Secret 20". Big input buffers/files leads 
> smack to recieve a rule like "Secret 20" in fragmented chunks like:
> 
> write("<lots of rules before ours>\nSec", ..)
> write("r", 1, ..)
> write("et 20\n<remaing rules after ours>", ..)
> 
> Parsing a rule in such tough conditions in _kernel space_ is very
> hard. I began to feel that it will be much easier if we do the parsing 
> in a userspace utility and let smack accept only small buffers (80 char). 

For crying out louf, all it takes is a finite state machine...  BTW, folks,
your parser *and* input language suck.  Really.  Silently allowing noise
is Dumb(tm).

Please, write the grammar down and _follow_ _it_.  AFAICS, trimming the
crap ("we have a number, skip everything until '/', whatever noise we
have there doesn't matter") leads to something like

text: (whitespace line? \n)*
whitespace: [ \t]*
line: label whitespace number whitespace (/ whitespace set whitespace)?
set: number (whitespace , whitespace number)*
label: [!-.0-~]{1,23}
number: [0-9]+

and even that might be too liberal.  For fsck sake, all you need is to
keep a struct that would contain
	* state
	* (partial) number
	* list of smack_known, with the first element being the partial one.
	* number of characters already seen in label (label itself stored
in the list head ->smk_known)
and that's it - just have a switch by ->state to handle the next character.
Allocate that struct in ->open(), modify in ->write(), apply the entire thing
at once in ->release().

Come on, people, this is ridiculous - why bother reinventing the wheels for
the stuff that belongs to exercises halfway through any self-respecting
introductory textbook?  Scary parser, my arse...
