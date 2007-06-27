Return-Path: <linux-kernel-owner+w=401wt.eu-S1758135AbXF0K7T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758135AbXF0K7T (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jun 2007 06:59:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754914AbXF0K7H
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Jun 2007 06:59:07 -0400
Received: from smtpout.mac.com ([17.250.248.174]:57304 "EHLO smtpout.mac.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754350AbXF0K7G (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jun 2007 06:59:06 -0400
In-Reply-To: <20070627022403.GB14656@suse.de>
References: <20070626230756.519733902@suse.de> <20070626165202.bfe8e6df.akpm@linux-foundation.org> <20070627022403.GB14656@suse.de>
Mime-Version: 1.0 (Apple Message framework v752.2)
Content-Type: text/plain; charset=US-ASCII; delsp=yes; format=flowed
Message-Id: <0BE96E7A-204A-4CEC-BA8F-0112434F7B2C@mac.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-security-module@vger.kernel.org, linux-fsdevel@vger.kernel.org
Content-Transfer-Encoding: 7bit
From: Kyle Moffett <mrmacman_g4@mac.com>
Subject: Re: [AppArmor 00/44] AppArmor security module overview
Date: Wed, 27 Jun 2007 06:58:46 -0400
To: John Johansen <jjohansen@suse.de>
X-Mailer: Apple Mail (2.752.2)
X-Brightmail-Tracker: AAAAAA==
X-Brightmail-scanned: yes
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Jun 26, 2007, at 22:24:03, John Johansen wrote:
> other issues that have been raised are:
> - the use of d_path to generate the pathname used for mediation when a
>   file is opened.
>   - Generating the pathname using a reverse walk is considered ugly

A little more than "ugly".  In this basic concurrent rename() and  
path-lookup load:

mkdir -p /a/b/0
mkdir -p /a/b/2
mkdir -p /c
touch /a/b/0/1

cd /a/b
while true; mv 0/1 2/3; mv 2/3 0/1; done &
cd /
while true; do mv a/b c/d; mv c/d a/b; done &
while true; do cat a/b/0/1 & done
while true; do cat a/b/2/3 & done
while true; do cat c/d/0/1 & done
while true; do cat c/d/2/3 & done

I seem to recall you could actually end up racing and building a path  
to the file in those directories as "a/d/0/3" or some other path at  
which it never even remotely existed.  I'd love to be wrong, but I  
can't help but see this problem in any reverse-pathname-generation  
proposal which gets the locking right.

Cheers,
Kyle Moffett

