Return-Path: <linux-kernel-owner+w=401wt.eu-S1755047AbZFHSo1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755047AbZFHSo1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Jun 2009 14:44:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750784AbZFHSoT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Jun 2009 14:44:19 -0400
Received: from e33.co.us.ibm.com ([32.97.110.151]:50500 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750725AbZFHSoT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Jun 2009 14:44:19 -0400
Subject: Re: [PATCH] integrity: fix IMA inode leak
From: Mimi Zohar <zohar@linux.vnet.ibm.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Hugh Dickins <hugh.dickins@tiscali.co.uk>, Mimi Zohar <zohar@us.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Serge Hallyn <serue@us.ibm.com>, James Morris <jmorris@namei.org>,
       Al Viro <viro@zeniv.linux.org.uk>, linux-kernel@vger.kernel.org,
       linux-security-module@vger.kernel.org,
       David Safford <safford@watson.ibm.com>
In-Reply-To: <alpine.LFD.2.01.0906080913020.6847@localhost.localdomain>
References: <Pine.LNX.4.64.0906062109580.8365@sister.anvils>
	 <alpine.LFD.2.01.0906061416170.6847@localhost.localdomain>
	 <1244354901.3963.23.camel@dyn9002018117.watson.ibm.com>
	 <alpine.LFD.2.01.0906071608040.6847@localhost.localdomain>
	 <1244464135.3277.13.camel@dyn9002018117.watson.ibm.com>
	 <alpine.LFD.2.01.0906080913020.6847@localhost.localdomain>
Content-Type: text/plain
Date: Mon, 08 Jun 2009 14:44:15 -0400
Message-Id: <1244486655.3277.65.camel@dyn9002018117.watson.ibm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 (2.24.5-1.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-06-08 at 09:15 -0700, Linus Torvalds wrote:
> 
> On Mon, 8 Jun 2009, Mimi Zohar wrote:
> > 
> > Today the security calls are synomymous with MAC.  If I understand
> > correctly, you're suggesting we need to have a single security layer,
> > which, depending on the hook, calls either MAC or integrity, or both.
> 
> I don't think we need a single security layer per se.
> 
> But I do think that we _already_ hide IMA conceptually under the 
> "security/" subdirectory, and that the VFS layer shouldn't need to care 
> about whatever internal details.
> 
> We should not have generic code end up having to know about all the 
> details, when we already have a conceptual nesting. It would be much 
> better for generic code to just have to worry about one security hook that 
> then encompasses all the models, than having several different hooks for 
> each detail.
> 
> 		Linus

Ok, so instead of having a full fledge single security layer, only add
the security layer for those places where both the LSM hooks and IMA
co-exist: security_file_mmap, security_bprm_check, security_inode_alloc,
security_inode_free, and security_file_free. As the LSM hooks are called
'security_XXXX', the call would look something like:

security_all_inode_free() {
        ima_inode_free()
        security_inode_free()
}

Mimi Zohar


