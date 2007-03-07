Return-Path: <linux-kernel-owner+w=401wt.eu-S932279AbXCGP4Z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932279AbXCGP4Z (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2007 10:56:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932253AbXCGP4Z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Mar 2007 10:56:25 -0500
Received: from nz-out-0506.google.com ([64.233.162.232]:48196 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932279AbXCGP4Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2007 10:56:24 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=U9KLA2SUacxQ0hDwnL2ymaOQA4bjPZIRsZcsIru0A6cBIqQxQqPl5aKNLctXBYOaIO1fK+QA//XajVjhmYSyyT0dRCzPBtWP5gHq3N+m8uV/uHtXy7hOthGMIlE+tnYz2BX38QBcmZA1rAOw6oG0Hd1BBDRuMj3r6Aitd8IGEaU=
Message-ID: <d120d5000703070756v4fe11a54u9009d3efd93faa9d@mail.gmail.com>
Date: Wed, 7 Mar 2007 10:56:22 -0500
From: "Dmitry Torokhov" <dmitry.torokhov@gmail.com>
To: "Linus Torvalds" <torvalds@linux-foundation.org>
Subject: Re: 2.6.21-rc suspend regression: sysfs deadlock
Cc: "Hugh Dickins" <hugh@veritas.com>, "Oliver Neukum" <oliver@neukum.name>,
       "Maneesh Soni" <maneesh@in.ibm.com>,
       "Greg Kroah-Hartman" <gregkh@suse.de>, "Adrian Bunk" <bunk@stusta.de>,
       linux-kernel@vger.kernel.org
In-Reply-To: <Pine.LNX.4.64.0703061735350.5963@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <Pine.LNX.4.64.0703061914030.18144@blonde.wat.veritas.com>
	 <Pine.LNX.4.64.0703061735350.5963@woody.linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 3/6/07, Linus Torvalds <torvalds@linux-foundation.org> wrote:
>
>  - removing the buffer is now just
>
>        mutex_lock(&inode->i_mutex);
>        buffer = inode->i_private;
>        inode->i_private = NULL;
>        mutex_unlock(&inode->i_mutex);
>
>        put_sysfs_buffer(buffer);
>
>  - everybody is happy!
>

... with the exception that it will again make data associated with
sysfs attributes accessible past the point of returning from
sysfs_remove_file. And that was the point so drivers would not have to
care about handling access to extra data (such as static strings) past
the driver unload.

I wonder if we should keep Oliver's change and require attribute
implementations to offload "delete me" kind of actions to workqueues.

-- 
Dmitry
