Return-Path: <linux-kernel-owner+w=401wt.eu-S1753466AbYK1SDJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753466AbYK1SDJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Nov 2008 13:03:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752487AbYK1SCv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Nov 2008 13:02:51 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:36213 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752295AbYK1SCt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Nov 2008 13:02:49 -0500
Date: Fri, 28 Nov 2008 19:02:20 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Eric Dumazet <dada1@cosmosbay.com>, David Miller <davem@davemloft.net>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, linux-kernel@vger.kernel.org,
       kernel-testers@vger.kernel.org, Mike Galbraith <efault@gmx.de>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Linux Netdev List <netdev@vger.kernel.org>,
       Christoph Lameter <cl@linux-foundation.org>,
       Christoph Hellwig <hch@infradead.org>, rth@twiddle.net,
       ink@jurassic.park.msu.ru
Subject: Re: [PATCH 6/6] fs: Introduce kern_mount_special() to mount
	special vfs
Message-ID: <20081128180220.GK10487@elte.hu>
References: <20081121083044.GL16242@elte.hu> <49267694.1030506@cosmosbay.com> <20081121.010508.40225532.davem@davemloft.net> <4926AEDB.10007@cosmosbay.com> <4926D022.5060008@cosmosbay.com> <20081121152148.GA20388@elte.hu> <4926D39D.9050603@cosmosbay.com> <20081121153453.GA23713@elte.hu> <492DDCAB.1070204@cosmosbay.com> <20081128092604.GL28946@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081128092604.GL28946@ZenIV.linux.org.uk>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Al Viro <viro@ZenIV.linux.org.uk> wrote:

> On Thu, Nov 27, 2008 at 12:32:59AM +0100, Eric Dumazet wrote:
> > This function arms a flag (MNT_SPECIAL) on the vfs, to avoid
> > refcounting on permanent system vfs.
> > Use this function for sockets, pipes, anonymous fds.
> 
> IMO that's pushing it past the point of usefulness; unless you can show
> that this really gives considerable win on pipes et.al. *AND* that it
> doesn't hurt other loads...

The numbers look pretty convincing:

> >  (socket8 bench result : from 2.94s to 2.23s)

And i wouldnt expect it to hurt real-filesystem workloads.

Here's the contemporary trace of a typical ext3- sys_open():

 0)               |  sys_open() {
 0)               |    do_sys_open() {
 0)               |      getname() {
 0)      0.367 us |        kmem_cache_alloc();
 0)               |        strncpy_from_user(); {
 0)               |          _cond_resched() {
 0)               |            need_resched() {
 0)      0.363 us |              constant_test_bit();
 0)      1. 47 us |            }
 0)      1.815 us |          }
 0)      2.587 us |        }
 0)      4. 22 us |      }
 0)               |      alloc_fd() {
 0)      0.480 us |        _spin_lock();
 0)      0.487 us |        expand_files();
 0)      2.356 us |      }
 0)               |      do_filp_open() {
 0)               |        path_lookup_open() {
 0)               |          get_empty_filp() {
 0)      0.439 us |            kmem_cache_alloc();
 0)               |            security_file_alloc() {
 0)      0.316 us |              cap_file_alloc_security();
 0)      1. 87 us |            }
 0)      3.189 us |          }
 0)               |          do_path_lookup() {
 0)      0.366 us |            _read_lock();
 0)               |            path_walk() {
 0)               |              __link_path_walk() {
 0)               |                inode_permission() {
 0)               |                  ext3_permission() {
 0)      0.441 us |                    generic_permission();
 0)      1.247 us |                  }
 0)               |                  security_inode_permission() {
 0)      0.411 us |                    cap_inode_permission();
 0)      1.186 us |                  }
 0)      3.555 us |                }
 0)               |                do_lookup() {
 0)               |                  __d_lookup() {
 0)      0.486 us |                    _spin_lock();
 0)      1.369 us |                  }
 0)      0.442 us |                  __follow_mount();
 0)      3. 14 us |                }
 0)               |                path_to_nameidata() {
 0)      0.476 us |                  dput();
 0)      1.235 us |                }
 0)               |                inode_permission() {
 0)               |                  ext3_permission() {
 0)               |                    generic_permission() {
 0)               |                      in_group_p() {
 0)      0.410 us |                        groups_search();
 0)      1.172 us |                      }
 0)      1.994 us |                    }
 0)      2.789 us |                  }
 0)               |                  security_inode_permission() {
 0)      0.454 us |                    cap_inode_permission();
 0)      1.238 us |                  }
 0)      5.262 us |                }
 0)               |                do_lookup() {
 0)               |                  __d_lookup() {
 0)      0.480 us |                    _spin_lock();
 0)      1.621 us |                  }
 0)      0.456 us |                  __follow_mount();
 0)      3.215 us |                }
 0)               |                path_to_nameidata() {
 0)      0.420 us |                  dput();
 0)      1.193 us |                }
 0) +   23.551 us |              }
 0)               |              path_put() {
 0)      0.420 us |                dput();
 0)               |                mntput() {
 0)      0.359 us |                  mntput_no_expire();
 0)      1. 50 us |                }
 0)      2.544 us |              }
 0) +   27.253 us |            }
 0) +   28.850 us |          }
 0) +   33.217 us |        }
 0)               |        may_open() {
 0)               |          inode_permission() {
 0)               |            ext3_permission() {
 0)      0.480 us |              generic_permission();
 0)      1.229 us |            }
 0)               |            security_inode_permission() {
 0)      0.405 us |              cap_inode_permission();
 0)      1.196 us |            }
 0)      3.589 us |          }
 0)      4.600 us |        }
 0)               |        nameidata_to_filp() {
 0)               |          __dentry_open() {
 0)               |            file_move() {
 0)      0.470 us |              _spin_lock();
 0)      1.243 us |            }
 0)               |            security_dentry_open() {
 0)      0.344 us |              cap_dentry_open();
 0)      1.139 us |            }
 0)      0.412 us |            generic_file_open();
 0)      0.561 us |            file_ra_state_init();
 0)      5.714 us |          }
 0)      6.483 us |        }
 0) +   46.494 us |      }
 0)      0.453 us |      inotify_dentry_parent_queue_event();
 0)      0.403 us |      inotify_inode_queue_event();
 0)               |      fd_install() {
 0)      0.440 us |        _spin_lock();
 0)      1.247 us |      }
 0)               |      putname() {
 0)               |        kmem_cache_free() {
 0)               |          virt_to_head_page() {
 0)      0.369 us |            constant_test_bit();
 0)      1. 23 us |          }
 0)      1.738 us |        }
 0)      2.422 us |      }
 0) +   60.560 us |    }
 0) +   61.368 us |  }

and here's a sys_close():

 0)               |  sys_close() {
 0)      0.540 us |    _spin_lock();
 0)               |    filp_close() {
 0)      0.437 us |      dnotify_flush();
 0)      0.401 us |      locks_remove_posix();
 0)      0.349 us |      fput();
 0)      2.679 us |    }
 0)      4.452 us |  }

i'd be surprised to see a flag to show up in that codepath. Eric, does 
your testing confirm that?

	Ingo
