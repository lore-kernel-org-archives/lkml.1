Return-Path: <linux-kernel-owner+w=401wt.eu-S1754688AbYLISIe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754688AbYLISIe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Dec 2008 13:08:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753573AbYLISI0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Dec 2008 13:08:26 -0500
Received: from nf-out-0910.google.com ([64.233.182.190]:36362 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752976AbYLISIZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Dec 2008 13:08:25 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=Aso2jv9+OiDY9agI86cSpoly8DVVMQ4+9a1RUuV8OhlSLp2dwAqzxb29i4YeqX/G00
         2Fh2qWDCZGOYu+jh2HRbCMT6BgVkAclA1QNUZpBKZ3HaJkUvwlEetU0wsAe6YR/SkUcT
         rqhQTTAsHMZEg4c/jS1QFEpw+gmmEmQQzLsI4=
Message-ID: <493EB22C.2050108@panasas.com>
Date: Tue, 09 Dec 2008 20:00:12 +0200
From: Boaz Harrosh <bharrosh@panasas.com>
User-Agent: Thunderbird/3.0a2 (X11; 2008072418)
MIME-Version: 1.0
To: Christoph Hellwig <hch@infradead.org>
CC: Andrew Morton <akpm@linux-foundation.org>,
       Duane Griffin <duaneg@dghda.com>, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org
Subject: Re: Checking link targets are NULL-terminated
References: <20081205144810.GA25585@dastardly.home.dghda.com> <20081208143003.9449bc77.akpm@linux-foundation.org> <20081209171814.GA8667@infradead.org>
In-Reply-To: <20081209171814.GA8667@infradead.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Christoph Hellwig wrote:
> On Mon, Dec 08, 2008 at 02:30:03PM -0800, Andrew Morton wrote:
>> Perhaps nd_set_link() is a suitable place?  Change that function so
>> that it is passed a third argument (max_len) and then check that within
>> nd_set_link().  Change nd_set_link() to return a __must_check-marked
>> errno, change callers to handle errors appropriately.
>>
>> Or something totally different ;)  But along those lines?
> 
> Note that XFS and possibly other filesystem don't store the NULL
> termination on disk.  

Note that ext2, for example, also only writes the string bytes without
any NULLs. It only happen to be zero padded because any last-page is zero-padded
from i_size to end of page.

> So having a follow_link interface that uses a
> counted string would be a nice little optimization for the XFS
> follow_link / readlink implementation.   But I'm not really sure it's
> worth complicating the VFS for that little gem.
> 

The inode's i_size already holds the string count so at the higher level
we have that information. But I'm convinced, nd_set_link() should receive
a new max_len, all users should be changed as a matter of code audit.
nd_set_link() should then proceed to truncate the string at that length
unconditionally no need for error returns.

My $0.017
Boaz
