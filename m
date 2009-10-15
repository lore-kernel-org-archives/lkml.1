Return-Path: <linux-kernel-owner+w=401wt.eu-S1762897AbZJOQYY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762897AbZJOQYY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Oct 2009 12:24:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762887AbZJOQYX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Oct 2009 12:24:23 -0400
Received: from mx1.redhat.com ([209.132.183.28]:8900 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762884AbZJOQYW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Oct 2009 12:24:22 -0400
Date: Thu, 15 Oct 2009 13:04:23 -0300
From: Marcelo Tosatti <mtosatti@redhat.com>
To: "Darrick J. Wong" <djwong@us.ibm.com>
Cc: Avi Kivity <avi@redhat.com>, linux-kernel <linux-kernel@vger.kernel.org>,
       kvm@vger.kernel.org
Subject: Re: [PATCH] kvm: Prevent kvm_init from corrupting debugfs
	structures
Message-ID: <20091015160423.GC9629@amt.cnet>
References: <20091014232100.GE26149@tux1.beaverton.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091014232100.GE26149@tux1.beaverton.ibm.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 14, 2009 at 04:21:00PM -0700, Darrick J. Wong wrote:
> I'm seeing an oops condition when kvm-intel and kvm-amd are modprobe'd
> during boot (say on an Intel system) and then rmmod'd:
> 
>    # modprobe kvm-intel
>      kvm_init()
>      kvm_init_debug()
>      kvm_arch_init()  <-- stores debugfs dentries internally
>      (success, etc)
> 
>    # modprobe kvm-amd
>      kvm_init()
>      kvm_init_debug() <-- second initialization clobbers kvm's
>                           internal pointers to dentries
>      kvm_arch_init()
>      kvm_exit_debug() <-- and frees them
> 
>    # rmmod kvm-intel
>      kvm_exit()
>      kvm_exit_debug() <-- double free of debugfs files!
> 
>      *BOOM*
> 
> If execution gets to the end of kvm_init(), then the calling module has been
> established as the kvm provider.  Move the debugfs initialization to the end of
> the function, and remove the now-unnecessary call to kvm_exit_debug() from the
> error path.  That way we avoid trampling on the debugfs entries and freeing
> them twice.
> 
> Signed-off-by: Darrick J. Wong <djwong@us.ibm.com>

Applied, thanks.

