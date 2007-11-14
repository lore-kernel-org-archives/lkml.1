Return-Path: <linux-kernel-owner+w=401wt.eu-S1760839AbXKNVTl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760839AbXKNVTl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2007 16:19:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754153AbXKNVTe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Nov 2007 16:19:34 -0500
Received: from gate.crashing.org ([63.228.1.57]:39639 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754857AbXKNVTd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2007 16:19:33 -0500
Mime-Version: 1.0 (Apple Message framework v752.2)
Content-Transfer-Encoding: 7bit
Message-Id: <4DACDAEF-A2B4-438D-A330-85FD5E65E3DE@kernel.crashing.org>
Content-Type: text/plain; charset=US-ASCII; delsp=yes; format=flowed
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
From: Kumar Gala <galak@kernel.crashing.org>
Subject: generic_setlease and tmpfs -- LTP fcntl failure
Date: Wed, 14 Nov 2007 15:19:31 -0600
X-Mailer: Apple Mail (2.752.2)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

In debugging a LTP failure related to fcntl on tmpfs it appears that  
we aren't able to use fcntl(fd, F_SETLEASE, F_WRLCK).  In the  
debugging it looks like we artificial increase the dentry->d_count  
and so generic_setlease() always fails with -EAGAIN since it appears  
dentry->d_count will be 2.

This is my first time delving into fs code so I'm not that familiar  
with why tmpfs is artificially increasing the d_count.  I was  
wondering what a possible solution would be.

Maybe something like:

shmem_setlease(...) {
	if (arg == F_WRLCK) {
		dput(dentry)
		generic_setlease(...)
		dget(dentry)
	} else {
		generic_setlease(...)
	}
}

Not sure what harm doing the dput() / dget() will have.

- k
