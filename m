Return-Path: <linux-kernel-owner+w=401wt.eu-S1756072AbYE3CFj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756072AbYE3CFj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2008 22:05:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752728AbYE3CF3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 May 2008 22:05:29 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43805 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752711AbYE3CF3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2008 22:05:29 -0400
Date: Thu, 29 May 2008 19:04:27 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Mimi Zohar <zohar@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, safford@watson.ibm.com,
       serue@linux.vnet.ibm.com, sailer@watson.ibm.com, zohar@us.ibm.com,
       sds@tycho.nsa.gov, casey@schaufler-ca.com
Subject: Re: [RFC][Patch 5/5]integrity: IMA as an integrity service provider
Message-Id: <20080529190427.81d7301a.akpm@linux-foundation.org>
In-Reply-To: <1212112688.4722.10.camel@new-host.home>
References: <1211555145.16195.18.camel@new-host>
	<20080528012242.a0e98d87.akpm@linux-foundation.org>
	<1212031046.4747.57.camel@new-host.home>
	<20080528203013.5a927d30.akpm@linux-foundation.org>
	<1212097834.15923.7.camel@localhost.localdomain>
	<20080529163501.5a672b8f.akpm@linux-foundation.org>
	<1212112688.4722.10.camel@new-host.home>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 29 May 2008 21:58:08 -0400 Mimi Zohar <zohar@linux.vnet.ibm.com> wrote:

> > erk, I'm not an i_version person.  It seems that it's only used on
> > directories (to patch up readdir coherency problems) so I guess I
> > misled you there.
> 
> No, no.  Initially, that's what I thought. I finally found
> file_update_time() calls inode_inc_iversion(), which updates 
> the i_version.  So, it does work.  The question is whether
> or not it works all the time. :-)

OK.

Before 2.6.17 it wouldn't have worked much at all on MAP_SHARED
modifications.

After 2.6.17 things will be better - we update the mtime on the
clean->dirty transitions of a page.  So the first modification after an
mmap will update the time.

Subsequent modifications via the mmap will not update the file time. 
Until something (usually pdflush) writes the page out.  Then the next
modification via mmap will cause another clean->dirty transition on the
page, hence another mtime update.

So there's a by-default 30-odd second uncertainty with MAP_SHARED
alterations.

