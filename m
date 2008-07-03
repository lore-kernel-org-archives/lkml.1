Return-Path: <linux-kernel-owner+w=401wt.eu-S1753302AbYGCA7c@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753302AbYGCA7c (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jul 2008 20:59:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751562AbYGCA7Y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Jul 2008 20:59:24 -0400
Received: from palinux.external.hp.com ([192.25.206.14]:57846 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751263AbYGCA7Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2008 20:59:24 -0400
Date: Wed, 2 Jul 2008 18:59:07 -0600
From: Matthew Wilcox <matthew@wil.cx>
To: linux-kernel@vger.kernel.org
Subject: Re: Ctrl+C doesn't interrupt process waiting for I/O
Message-ID: <20080703005907.GZ14894@parisc-linux.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


I'd like to correct a few misapprehensions in this thread.  To be fair,
what they were saying used to be true, but it isn't any more, and I
would like people to be aware of it.

Avi Kivity wrote:
> That's filesystem dependent; if you mount an nfs filesystem with the 
> 'intr' mount option, it will be interruptible (which makes sense, as it 
> is impossible to guarantee the server's responsiveness).

As of v2.6.25, 'intr' is a no-op.  The option is still recognised, but
it does not change NFS's behaviour.

Bill Davidson wrote:
> Basic problem is that you can get a process which you can't interrupt 
> (in in most cases can't kill) which has resources tied up. Given the 
> choice between surprising a process with an EINTR or killing it during a 
> reboot to get the system usable again, I would rather surprise.

I implemented option C (none of the above).  NFS now sleeps in state
TASK_KILLABLE so tasks can be killed, but they will never see the -EINTR
return (since they're dead).  Yes, that means you can end up with a
partial write to a file on the server.  But if you tripped over the
(power/network) cable, that could happen anyway.

-- 
Intel are signing my paycheques ... these opinions are still mine
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
