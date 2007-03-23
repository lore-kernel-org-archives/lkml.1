Return-Path: <linux-kernel-owner+w=401wt.eu-S1752917AbXCWCeY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752917AbXCWCeY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Mar 2007 22:34:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752920AbXCWCeX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Mar 2007 22:34:23 -0400
Received: from ms-smtp-03.texas.rr.com ([24.93.47.42]:56075 "EHLO
	ms-smtp-03.texas.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753024AbXCWCeV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Mar 2007 22:34:21 -0400
Subject: Re: CIFS: reset ATTR_READONLY on Windows
From: Steve French <smfrench@austin.rr.com>
To: Urs Fleisch <urs.fleisch@gmail.com>, linux-kernel@vger.kernel.org,
       linux-cifs-client@lists.samba.org
Content-Type: text/plain
Date: Thu, 22 Mar 2007 22:35:36 -0500
Message-Id: <1174620936.4401.15.camel@smf-t60p.smfdom>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> When all write permission bits are removed from a file on 
> the Windows share (e.g. using chmod ugo-w filename), the 
> read-only bit is set in the file (as seen in the Windows Explorer).
> Now it is not possible to get the  write permissions back (e.g. using
chmod ugo+w filename). The read-only  
> bit has to be removed in the Windows Explorer. When this is done, 
> the file is still displayed to be read-only (ls -l filename), 
> but it can be made writeable (chmod ugo+w filename). When the 
> patch from the message  mentioned above is applied (discovered 
> by Alan Tyson of HP, reported by Jeff Layton), the writeable bits 
> are displayed correctly as soon as the read-only bit is
> removed in the Windows Explorer. The main problem,  
> however, still exists as it is not possible to make the 
> file writeable from the Linux CIFS client.

> Investigating the problem further, I found out that the problem occurs  
> only if no other attribute is set on the file. If I set the archived or  
> hidden bit in the Windows Explorer or unmark the "for fast searching,  
> allow Indexing Service to index this file" checkbox (which sets the  
> ATTR_NOT_CONTENT_INDEXED bit), the read-only bit can be cleared from the  
> Linux client. Looking into the function cifs_setattr() in fs/cifs/inode.c
> and adding some debug output, it can be seen that time_buf.Attributes is  
> zero in the problem case and the attribute will not be set. Sending the  
> attributes with a zero value does not help as this seems to mean that no  
> attributes have to be changed. So I added the ATTR_NORMAL bit in the case  
> where ATTR_READONLY has to be cleared and no other attribute is set.

Urs,
Yes - you were correct.  Good catch.  Thanks. The patch I put in the cifs
tree was implemented slightly differently (I did not read the 2nd half of
your email until too late) but is a similar idea.   Would you take a look
at it?

http://master.kernel.org/git/?p=linux/kernel/git/sfrench/cifs-2.6.git;a=commitdiff;h=066fcb06d3e27c258bc229bb688ced2b16daa6c2

> I made another small change: The ATTR_READONLY is only cleared if all  
> writeable bits are set in the Linux permissions (the file is writeable for  
> user, group and others). This is caused by the check ((mode & S_IWUGO) ==  
> S_IWUGO). I think that this does not make sense, as soon as any write flag  
> is set, the file is no longer read-only.

I agree that the 2nd change is intuitive, but it changes behavior slightly
more - and this close to the next point release coming out I would
rather fix the bug the least risky way.

Fortunately this compensation won't matter as much when the code is finished
to store the mode in the CIFS ACL for those type of servers.  I am tempted
to just save the mode in an xattr (actually OS/2 EA which NTFS still supports) 
for these cases.

