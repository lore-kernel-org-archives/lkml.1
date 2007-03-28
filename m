Return-Path: <linux-kernel-owner+w=401wt.eu-S933631AbXC1HQ6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933631AbXC1HQ6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Mar 2007 03:16:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933753AbXC1HQ6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Mar 2007 03:16:58 -0400
Received: from wx-out-0506.google.com ([66.249.82.230]:3206 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933631AbXC1HQ5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Mar 2007 03:16:57 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=DIN7aSsn/ggb4Jpcdl/G4lH9trAT+4d9SWgGFPjkHqK2XTNinS0N2islLm2b/sfaEaXBRT/Pc2c6OUS85WCMhS8DtO85pY45BKBpz5QCPnTESnHUrhAZnm1lL80zWabS7AGym7CO/YC5zGdqVxR9Rm7TnUmdZYPUOWHqPG5rm8U=
Message-ID: <57290de70703280016n2c79cb4cg6aab4da7a8a10b0f@mail.gmail.com>
Date: Wed, 28 Mar 2007 09:16:56 +0200
From: "Urs Fleisch" <urs.fleisch@gmail.com>
To: "Steve French" <smfrench@austin.rr.com>
Subject: Re: CIFS: reset ATTR_READONLY on Windows
Cc: linux-kernel@vger.kernel.org, linux-cifs-client@lists.samba.org
In-Reply-To: <1174620936.4401.15.camel@smf-t60p.smfdom>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1174620936.4401.15.camel@smf-t60p.smfdom>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> Would you take a look at it?
The patch looks fine, similar to mine, I also used a flag when trying
to send a zero attribute to the server, but removed it later to reduce
the number of differences.

>> I made another small change: The ATTR_READONLY is only cleared if all
>> writeable bits are set in the Linux permissions (the file is writeable for
>> user, group and others). This is caused by the check ((mode &
>> S_IWUGO) == S_IWUGO). I think that this does not make sense, as soon
>> as any write flag is set, the file is no longer read-only.
>
> I agree that the 2nd change is intuitive, but it changes behavior slightly
> more - and this close to the next point release coming out I would
> rather fix the bug the least risky way.

The current behavior is not only unintuitive, it is also inconsistent.
When having a file_mode of 0755, read-only files on the Windows share
have permissions "-r-xr-xr-x" on the CIFS client, and writeable files
"-rwxr-xr-x". However, to make a file writeable, setting its
permissions to "-rwxr-xr-x" is not sufficient, you have to set
"-rwxrwxrwx". When setting permissions from the shell or a file
manager, it is possible to cope with it, however, if an application
has to control the read-only state, you have to set the file_mode to
0777, the umask to 0000 and hope that this will make the application
set all writeable bits. We have people that use subversion working
copies on Windows shares and want the read-only attribute to be set
correctly when locking and unlocking files.
