Return-Path: <linux-kernel-owner+w=401wt.eu-S1757284AbZJOHMe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757284AbZJOHMe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Oct 2009 03:12:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754107AbZJOHMe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Oct 2009 03:12:34 -0400
Received: from mx1.redhat.com ([209.132.183.28]:45270 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752251AbZJOHMd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Oct 2009 03:12:33 -0400
Message-ID: <4AD6CB42.5040006@redhat.com>
Date: Thu, 15 Oct 2009 16:12:02 +0900
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.1) Gecko/20090814 Fedora/3.0-2.6.b3.fc11 Thunderbird/3.0b3
MIME-Version: 1.0
To: djwong@us.ibm.com
CC: Marcelo Tosatti <mtosatti@redhat.com>,
       linux-kernel <linux-kernel@vger.kernel.org>, kvm@vger.kernel.org
Subject: Re: [PATCH] kvm: Prevent kvm_init from corrupting debugfs structures
References: <20091014232100.GE26149@tux1.beaverton.ibm.com>
In-Reply-To: <20091014232100.GE26149@tux1.beaverton.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/15/2009 08:21 AM, Darrick J. Wong wrote:
> I'm seeing an oops condition when kvm-intel and kvm-amd are modprobe'd
> during boot (say on an Intel system) and then rmmod'd:
>
>     # modprobe kvm-intel
>       kvm_init()
>       kvm_init_debug()
>       kvm_arch_init()<-- stores debugfs dentries internally
>       (success, etc)
>
>     # modprobe kvm-amd
>       kvm_init()
>       kvm_init_debug()<-- second initialization clobbers kvm's
>                            internal pointers to dentries
>       kvm_arch_init()
>       kvm_exit_debug()<-- and frees them
>
>     # rmmod kvm-intel
>       kvm_exit()
>       kvm_exit_debug()<-- double free of debugfs files!
>
>       *BOOM*
>
> If execution gets to the end of kvm_init(), then the calling module has been
> established as the kvm provider.  Move the debugfs initialization to the end of
> the function, and remove the now-unnecessary call to kvm_exit_debug() from the
> error path.  That way we avoid trampling on the debugfs entries and freeing
> them twice.
>
>    

Looks good.

-- 
I have a truly marvellous patch that fixes the bug which this
signature is too narrow to contain.

