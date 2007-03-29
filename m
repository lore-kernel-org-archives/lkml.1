Return-Path: <linux-kernel-owner+w=401wt.eu-S1030732AbXC2VEU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030732AbXC2VEU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Mar 2007 17:04:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030734AbXC2VEU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Mar 2007 17:04:20 -0400
Received: from e5.ny.us.ibm.com ([32.97.182.145]:60855 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030732AbXC2VET (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Mar 2007 17:04:19 -0400
Message-ID: <460C299F.1020000@us.ibm.com>
Date: Thu, 29 Mar 2007 16:03:27 -0500
From: "Steve French (smfltc)" <smfltc@us.ibm.com>
User-Agent: Mozilla Thunderbird 1.0 (Windows/20041206)
X-Accept-Language: en-us, en
MIME-Version: 1.0
To: undisclosed-recipients:;
Subject: Re: Can't mount NAS device
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

strace did show something useful
	mount(...) = -1 ENOTDIR (Not a directory)

and then that led me to spotting the obvious bug which is
on your NAS device (server).  The server is returning a
malformed (illegal) response.

The Linux cifs client was getting a 22 byte response to a level 0x200
(FILE_UNIX_BASIC_INFO) request that is supposed to be 100 bytes.

Basically connecting the mount to the server succeeded but 
the stat of "." (the top directory in the mount) failed 
since it is not recognized as a directory.

When you disable the Unix Extensions on the client ie
	echo 0 > /proc/fs/cifs/LinuxExtensionsEnabled
you bypass the bug on the server, because the response to
the call which is malformed is not issued (and an older
infolevel is requested).

If your server vendor produces a fix let me know and I can add
the information about the required level of server to 
the Linux cifs client "how-to" / user's guide.





